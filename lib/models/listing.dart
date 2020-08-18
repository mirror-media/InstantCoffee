class Listing {
  String title;
  String description;
  String photoUrl;
  String publishedAt;

  Listing({
    this.title,
    this.description,
    this.photoUrl,
    this.publishedAt,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      title: json['title'],
      description: json['description'],
      photoUrl: json['thumbnails']['medium']['url'],
      publishedAt: json['publishedAt'],
    );
  }
}