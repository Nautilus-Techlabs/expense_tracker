import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class DebugSmsRawScreen extends StatefulWidget {
  const DebugSmsRawScreen({super.key});

  @override
  State<DebugSmsRawScreen> createState() => _DebugSmsRawScreenState();
}

class _DebugSmsRawScreenState extends State<DebugSmsRawScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _isLoading = false;
  String _status = "Ready";
  final TextEditingController _addressController = TextEditingController();

  Future<void> _fetchRawSms({String? specificAddress}) async {
    setState(() {
      _isLoading = true;
      _status = "Requesting permission...";
      _messages = [];
    });

    final permission = await Permission.sms.request();
    if (permission.isGranted) {
      setState(() => _status = "Querying SMS...");
      try {
        final messages = await _query.querySms(
          kinds: [SmsQueryKind.inbox],
          address: specificAddress != null && specificAddress.isNotEmpty ? specificAddress : null,
          count: 5000, // Explicitly request a large count just in case
        );
        setState(() {
          _messages = messages;
          _status = "Found ${messages.length} total messages.";
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _status = "Error querying SMS: $e";
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _status = "SMS Permission denied.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raw SMS Debugger"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: "Enter exact Sender ID (e.g. AD-HDFCBK)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _fetchRawSms(specificAddress: _addressController.text),
                  child: const Text("Query Specific"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _fetchRawSms(),
                  child: const Text("Query All"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _status,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Text(msg.address ?? 'Unknown Sender'),
                  subtitle: Text(
                    "Date: ${msg.date}\nBody: ${msg.body}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
