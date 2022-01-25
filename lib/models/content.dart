class Content {
  String? data;
  double? aspectRatio;
  String? description;

  Content({
    this.data,
    this.aspectRatio,
    this.description,
  });

  factory Content.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json['mobile'] != null) {
        return Content(
          data: json['mobile']['url'],
          aspectRatio: json['mobile']['width'] / json['mobile']['height'],
          description: json['description'],
        );
      } else if (json['youtubeId'] != null) {
        return Content(
          data: json['youtubeId'],
          aspectRatio: null,
          description: json['description'],
        );
      } else if (json['filetype'] != null) {
        return Content(
          data: json['url'],
          aspectRatio: null,
          description: json['title'] + ';' + json['description'],
        );
      } else if (json['embeddedCode'] != null) {
        double? aspectRatio;

        if(json['width'] != null && 
          json['height'] != null && 
          json['width'] is String && 
          json['height'] is String) {
          aspectRatio = double.parse(json['width'])/double.parse(json['height']);
        }

        return Content(
          data: json['embeddedCode'],
          aspectRatio: aspectRatio,
          description: json['caption'],
        );
      } else if (json['draftRawObj'] != null) {
        return Content(
          data: json['body'],
          aspectRatio: null,
          description: json['title'],
        );
      } else if (json['quote'] != null) {
        return Content(
          data: json['quote'],
          aspectRatio: null,
          description: json['quoteBy'],
        );
      }

      return Content(data: null, aspectRatio: null, description: null);
    }

    return Content(
      data: json.toString(),
      aspectRatio: null,
      description: null,
    );
  }

  static List<Content> contentListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Content>((json) => Content.fromJson(json)).toList();
  }
}
