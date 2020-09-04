class FcmData {
  String slug;
  bool isListeningPage;

  FcmData({
    this.slug,
    this.isListeningPage,
  });

  factory FcmData.fromJson(Map<dynamic, dynamic> json) {
    if(json == null) {
      return null;
    }

    bool isListeningPage = false;
    if(json['_is_listening'] != null) {
      isListeningPage = json['_is_listening'].toLowerCase() == 'true';
    }

    return FcmData(
      slug: json['_open_slug'],
      isListeningPage: isListeningPage,
    );
  }
}