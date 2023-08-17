class People {
  String id;
  String name;

  People({
    required this.id,
    required this.name,
  });

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      id: json['_id']??json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };

  static List<People> peopleListFromJson(List<dynamic> jsonList) {
    return jsonList.map<People>((json) => People.fromJson(json)).toList();
  }
}
