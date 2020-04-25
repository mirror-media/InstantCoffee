class Tag {
  String id;
  String name;
  
  Tag({
    this.id,
    this.name,
  });
 
  factory Tag.fromJson(Map<String, dynamic> json){
    String id = json['_id'];

    return new Tag(
        id: id,
        name: json['name'],
    );
  }
}