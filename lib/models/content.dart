class Content {
  String data;
  String description;

  Content({
    this.data,
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
        description: json['description'],
      );
    }

    return Content(
      data: json.toString(),
      description: null,
    );
  }
}
