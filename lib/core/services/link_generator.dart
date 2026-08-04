import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkGenerator {
  DeepLinkGenerator._();

  static const String baseUrl = 'https://nt-epense-tracker-web.netlify.app';

  static String circleInvite(int circleId) =>
      '$baseUrl/invite?circleId=$circleId';
}

class ShareHelper {
  ShareHelper._();

  static Future<void> inviteCircle(int circleId) async {
    try {
      final inviteLink = DeepLinkGenerator.circleInvite(circleId);

      await SharePlus.instance.share(
        ShareParams(
          subject: 'Join my Expense Lite Circle',
          text:
              '''
💰 Join my Expense Lite Circle!

I've invited you to collaborate on shared expenses in Expense Lite.

Tap the link below to join:

$inviteLink
''',
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to share circle invite.${e.toString()}', stackTrace);
    }
  }
}
