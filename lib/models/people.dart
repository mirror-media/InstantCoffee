class People {
  String id;
  String name;

  People({
    this.id,
    this.name,
  });

  factory People.fromJson(Map<String, dynamic> json) {

    return People(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
      '_id': id,
      'name': name,
    };
}
