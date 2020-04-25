class Record {
  String title;
  String slug;
  String publishedDate;
  String photo;
 
  Record({
    this.title,
    this.slug,
    this.publishedDate,
    this.photo,
  });
 
  factory Record.fromJson(Map<String, dynamic> json){
    String origTitle = json['title'];
    String type;
    String photoUrl = 'https://www.mirrormedia.mg/assets/mirrormedia/notImage.png';
    final title = origTitle.replaceAll('　',"\n");
    if (json.containsKey('heroImage') && json['heroImage'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    }
    return new Record(
        title: origTitle,
        slug: json['slug'],
        publishedDate: json['publishedDate'],
        photo: photoUrl,
    );
  }
}
 