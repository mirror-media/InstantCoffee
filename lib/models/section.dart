import 'package:equatable/equatable.dart';
import 'package:readr_app/models/section_ad.dart';

// ignore: must_be_immutable
class Section extends Equatable {
  final String key;
  final String name;
  final String title;
  final String description;
  final bool focus;
  final int order;
  final String type;

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
    return Section(
      key: json["_id"] ?? json["key"],
      name: json["name"],
      title: json["title"],
      description: json["description"] ?? "",
      order: json["sortOrder"] ?? json["order"],
      focus: json['focus'] ?? false,
      type: json["type"] ?? "section",
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'title': title,
        'description': description,
        'order': order,
        'focus': focus,
        'type': type,
      };

  static List<Section> sectionListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Section>((json) => Section.fromJson(json)).toList();
  }

  @override
  List<Object?> get props =>
      [key, name, title, description, focus, order, type, sectionAd];
}
