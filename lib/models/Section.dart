class Section {
  String key;
  String name;
  String title;
  String description;
  bool focus;
  int order;
  String type;

  Section({
    this.key,
    this.name,
    this.title,
    this.description,
    this.order,
    this.focus,
    this.type,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    String type;
    if (json.containsKey("type") == true) {
      type = json["type"];
    } else {
      type = "section";
    }
    return Section(
      key: json["_id"] == null ? json["key"] : json["_id"],
      name: json["name"],
      title: json["title"],
      description: json["description"],
      order: json["sortOrder"] == null ? json["order"] : json["sortOrder"],
      focus: false,
      type: type,
    );
  } 

  void setOrder(int newOrder) {
    this.order = newOrder;
  }
}