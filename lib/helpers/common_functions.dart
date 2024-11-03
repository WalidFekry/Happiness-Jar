import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFunctions {
  static Future<void> shareMessage(String? message) async {
    await Share.share('$message \n\n من تطبيق برطمان السعادة 💙');
  }

  static void copyMessage(String? message) {
    FlutterClipboard.copy(
      '$message \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  static Future<void> shareWhatsapp(String? message) async {
    String shareMessage = '$message \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(shareMessage);
    String whatsappUrl = "https://api.whatsapp.com/send?text=$encodedMessage";
    Uri uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(shareMessage);
    }
  }

  static Future<void> shareFacebook(String? message) async {
    String shareMessage = '$message \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(shareMessage);
    String facebookUrl =
        "https://www.facebook.com/sharer/sharer.php?u=$encodedMessage";
    Uri uri = Uri.parse(facebookUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(shareMessage);
    }
  }
}
