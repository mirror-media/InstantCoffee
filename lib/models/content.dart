class Content {
  String data;
  double aspectRatio;
  String description;

  Content({
    this.data,
    this.aspectRatio,
    this.description,
  });

  factory Content.fromJson(dynamic json) {
    if(json is Map<String, dynamic>)
    {
      if(json['mobile'] == null) {
        return Content(data: null, description: null);
      }
      return Content(
        data: json['mobile']['url'],
        aspectRatio: json['mobile']['width']/json['mobile']['height'],
        description: json['description'],
      );
    }

    return Content(
      data: json.toString(),
      aspectRatio: null,
      description: null,
    );
  }
}
