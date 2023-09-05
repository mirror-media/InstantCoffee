import 'package:equatable/equatable.dart';
import 'package:readr_app/models/section_ad.dart';

// ignore: must_be_immutable
class Section extends Equatable {
  final String? key;
  final String? name;
  final String? title;
  final String? description;
  final bool? focus;
  final int? order;
  final String? type;

  SectionAd? sectionAd;

  Section({
     this.key,
     this.name,
     this.title,
     this.description,
     this.order,
     this.focus,
     this.type,
    this.sectionAd,
  });

  factory Section.fromJsonK6(Map<String, dynamic> json) {

    return Section(
      key: json["slug"],
      name: json["slug"],
      title: json["name"],
      description: json["description"] ?? "",
      order: json["order"],
      focus: json['focus'] ?? false,
      type: json["type"] ?? "section",
    );
  }


  factory Section.fromJson(Map<String, dynamic> json) {

    return Section(
      key: json["id"] ?? json["slug"],
      name: json["slug"],
      title: json["name"],
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
