import 'package:readr_app/models/sectionAd.dart';

class Section {
  String key;
  String name;
  String title;
  String description;
  bool focus;
  int order;
  String type;

  SectionAd? sectionAd;

  Section({
    required this.key,
    required this.name,
    required this.title,
    required this.description,
    required this.order,
    required this.focus,
    required this.type,
    
    this.sectionAd,
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
      description: json["description"] ?? "",
      order: json["sortOrder"] == null ? json["order"] : json["sortOrder"],
      focus: false,
      type: type,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'order': order,
        'key': key,
        'type': type,
        'description': description,
      };

  void setOrder(int newOrder) {
    this.order = newOrder;
  }

  static List<Section> sectionListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Section>((json) => Section.fromJson(json)).toList();
  }
}
