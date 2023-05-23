import 'package:url_launcher/url_launcher_string.dart';

class URLLauncher {
  launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
