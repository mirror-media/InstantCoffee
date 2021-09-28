import 'dart:convert';

class AppVersion {
  String platform;
  String majorVersion;
  String updateMessage;

  AppVersion({
    this.platform,
    this.majorVersion,
    this.updateMessage,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      platform: json['platform'],
      majorVersion: json['major version'],
      updateMessage: json['update message (show in app)']
    );
  }

  // A function that converts a response body into a List<AppVersion>.
  static List<AppVersion> parseAppVersion(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<AppVersion>((json) => AppVersion.fromJson(json)).toList();
  }
}