class Magazine {
  final String issue;
  final String title;
  final String publishedDate;
  final String photoUrl;
  final String pdfUrl;

  Magazine({
    this.issue,
    this.title,
    this.publishedDate,
    this.photoUrl,
    this.pdfUrl
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    String photoUrl = '';
    if (json.containsKey('coverPhoto') &&
        json['coverPhoto'] != null &&
        json['coverPhoto'].containsKey('image') &&
        json['coverPhoto']['image'] != null &&
        json['coverPhoto']['image'].containsKey('resizedTargets') && 
        json['coverPhoto']['image']['resizedTargets'] != null) {
      photoUrl = json['coverPhoto']['image']['resizedTargets']['mobile']['url'];
    }

    String pdfUrl = '';
    if (json.containsKey('magazine') &&
        json['magazine'] != null &&
        json['magazine'].containsKey('url')) {
      pdfUrl = json['magazine']['url'];
    }

    return Magazine(
      issue: json['issue'],
      //json['issue'] + json['issue'] + json['issue'] + json['issue']+ json['issue']+ json['issue']+ json['issue']+ json['issue'], 
      title: json['title'],
      publishedDate: json['publishedDate'],
      photoUrl: photoUrl,
      pdfUrl: pdfUrl,
    );
  }
}