class Section {
  String id;
  String name;
  String title;
  String description;
  bool focus;
  int order;
  String type;

  Section({
    this.id,
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
      id: json["_id"],
      name: json["name"],
      title: json["title"],
      description: json["description"],
      order: json["sortOrder"],
      focus: false,
      type: type,
    );
  }  
}