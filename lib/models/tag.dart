class Tag {
  String id;
  String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'] ??json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };

  static List<Tag> tagListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Tag>((json) => Tag.fromJson(json)).toList();
  }
}
