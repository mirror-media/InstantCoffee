class Listening {
  String slug;
  String title;
  String description;
  String photoUrl;
  String publishedAt;

  Listening({
    this.slug,
    this.title,
    this.description,
    this.photoUrl,
    this.publishedAt,
  });

  factory Listening.fromJson(Map<String, dynamic> json) {
    return Listening(
      slug: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      photoUrl: json['snippet']['thumbnails']['medium']['url'],
      publishedAt: json['snippet']['publishedAt'],
    );
  }
}