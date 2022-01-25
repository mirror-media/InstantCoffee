import 'dart:convert';

class Annotation {
  String text;
  String annotation;
  String pureAnnotationText;
  bool isExpanded;

  Annotation({
    required this.text,
    required this.annotation,
    required this.pureAnnotationText,
    this.isExpanded = false,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      text: json['text'],
      annotation: json['annotation'],
      pureAnnotationText: json['pureAnnotationText'],
      isExpanded: json['isExpanded'] ?? false,
    );
  }

  static Annotation? parseResponseBody(String? body) {
    if(body == null) {
      return null;
    }

    final jsonData = json.decode(body);
    return Annotation.fromJson(jsonData);
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'annotation': annotation,
        'pureAnnotationText': pureAnnotationText,
        'isExpanded': isExpanded,
      };
}
