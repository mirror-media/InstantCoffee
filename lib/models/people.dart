class People {
  String id;
  String name;

  People({
    this.id,
    this.name,
  });

  factory People.fromJson(Map<String, dynamic> json) {
    String id = json['_id'];

    return new People(
      id: id,
      name: json['name'],
    );
  }
}
