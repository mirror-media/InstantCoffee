class Listening {
  String title;
  String description;
  String photoUrl;
  String publishedAt;

  Listening({
    this.title,
    this.description,
    this.photoUrl,
    this.publishedAt,
  });

  factory Listening.fromJson(Map<String, dynamic> json) {
    return Listening(
      title: json['title'],
      description: json['description'],
      photoUrl: json['thumbnails']['medium']['url'],
      publishedAt: json['publishedAt'],
    );
  }
}