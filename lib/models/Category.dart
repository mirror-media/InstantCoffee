class Category {
  String id;
  String name;
  String title;
  bool isCampaign;

  Category({
    this.id,
    this.name,
    this.title,
    this.isCampaign,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String id = json['_id'];

    return new Category(
      id: id,
      name: json['name'],
      title: json['title'],
      isCampaign: json['isCampaign'],
    );
  }
}
