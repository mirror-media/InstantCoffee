import 'package:readr_app/helpers/environment.dart';

class Magazine {
  final String type;
  final String issue;
  final String title;
  final String publishedDate;
  final String photoUrl;
  final String pdfUrl;
  final String onlineReadingUrl;

  Magazine({
    this.type,
    this.issue,
    this.title,
    this.publishedDate,
    this.photoUrl,
    this.pdfUrl,
    this.onlineReadingUrl,
  });

  factory Magazine.fromJson(Map<String, dynamic> json, String type) {
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

    String onlineReadingUrl = '';
    if(type == 'weekly'){
      String issue = json['issue'];
      String book;
      String periodsString;
      if(issue.contains('A')){
        book = 'Book_A';
        periodsString = issue.replaceAll(new RegExp(r'[^0-9]'),'');
        periodsString = 'A' + periodsString;
      }else{
        book = 'Book_B';
        periodsString = issue.replaceAll(new RegExp(r'[^0-9]'),'');
        periodsString = 'B' + periodsString;
      }
      onlineReadingUrl = Environment().config.onlineMagazineUrl + '/$book/$periodsString-Publish/index.html#p=1';
    }

    return Magazine(
      type: type,
      issue: json['issue'],
      title: json['title'],
      publishedDate: json['publishedDate'],
      photoUrl: photoUrl,
      pdfUrl: pdfUrl,
      onlineReadingUrl: onlineReadingUrl,
    );
  }
}