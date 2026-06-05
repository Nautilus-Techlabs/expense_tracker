import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';


/// Service to run the TinyBERT int8 TFLite model on SMS text.
/// Loads the model, tokenizer assets, and provides a simple classification API.
class TfliteModelService {
  static final TfliteModelService _instance = TfliteModelService._internal();
  factory TfliteModelService() => _instance;

  TfliteModelService._internal();

  late final Interpreter _interpreter;
  late final int _inputLength; // e.g., 128 tokens
  late final Map<String, int> _vocab; // token -> id
  late final Map<int, String> _id2label; // output id -> label

  bool _initialized = false;

  /// Initialize the interpreter and load assets.
  Future<void> init() async {
    if (_initialized) return;
    // Load model
    final options = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset('model/model_int8_tf.tflite', options: options);

    // Load config to get input shape (assumes shape [1, seq_len])
    final configString = await rootBundle.loadString('model/config.json');
    final config = jsonDecode(configString) as Map<String, dynamic>;
    final inputShape = (config['input_shape'] as List).cast<int>();
    _inputLength = inputShape.length >= 2 ? inputShape[1] : 128;

    // Load tokenizer vocab (simple space‑split vocab for demo)
    final vocabString = await rootBundle.loadString('model/tokenizer.json');
    final vocabJson = jsonDecode(vocabString) as Map<String, dynamic>;
    // tokenizer.json may contain a "model" object with "vocab" list.
    if (vocabJson.containsKey('model')) {
      final model = vocabJson['model'] as Map<String, dynamic>;
      final vocabList = (model['vocab'] as List).cast<String>();
      _vocab = {for (var i = 0; i < vocabList.length; i++) vocabList[i]: i};
    } else {
      // fallback – empty vocab
      _vocab = {};
    }

    // Load label mapping
    final labelString = await rootBundle.loadString('model/label_mappings.json');
    final labelJson = jsonDecode(labelString) as Map<String, dynamic>;
    final id2labelRaw = labelJson['id2label'] as Map<String, dynamic>;
    _id2label = {for (var e in id2labelRaw.entries) int.parse(e.key): e.value as String};

    _initialized = true;
  }

  /// Convert raw SMS text into token IDs (very naïve whitespace split).
  List<int> _tokenize(String text) {
    final tokens = text.toLowerCase().split(RegExp(r"\\s+"));
    final ids = tokens.map((t) => _vocab[t] ?? 0).toList();
    // Pad / truncate to required length
    if (ids.length > _inputLength) {
      return ids.sublist(0, _inputLength);
    } else if (ids.length < _inputLength) {
      return ids + List.filled(_inputLength - ids.length, 0);
    }
    return ids;
  }
  /// Run inference on a single SMS string and return the predicted label(s).
  /// The model returns a 1‑D int8 tensor of size equal to number of classes.
  Future<List<String>> classifySms(String sms) async {
    try {
      await init();
      final inputIds = _tokenize(sms);
      // Prepare input Uint8List (int8) with required shape [_inputLength]
      final Uint8List input = Uint8List(_inputLength);
      for (int i = 0; i < _inputLength; i++) {
        input[i] = inputIds[i];
      }

      // Prepare output buffer
      final int outputSize = _id2label.length;
      final Uint8List output = Uint8List(outputSize);

      // Run interpreter
      _interpreter.run(input, output);

      // Convert int8 output to signed int list
      final List<int> outputList = output.map((b) => b.toSigned(8)).toList();
      // Find index with highest value
      int maxIdx = 0;
      int maxVal = outputList[0];
      for (int i = 1; i < outputList.length; i++) {
        if (outputList[i] > maxVal) {
          maxVal = outputList[i];
          maxIdx = i;
        }
      }
      final label = _id2label[maxIdx] ?? 'unknown';
      return [label];
    } catch (e) {
      print('TfliteModelService classification error: $e');
      return [];
    }
  }

}
