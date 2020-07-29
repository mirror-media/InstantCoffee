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

    return Category(
      id: json['_id'],
      name: json['name'],
      title: json['title'],
      isCampaign: json['isCampaign'],
    );
  }
}
