class Category {
  String id;
  String name;
  String title;
  bool isCampaign;
  bool isSubscribed;
  bool isMemberOnly;

  Category({
    this.id,
    this.name,
    this.title,
    this.isCampaign,
    this.isSubscribed,
    this.isMemberOnly,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      title: json['title'],
      isCampaign: json['isCampaign'],
      isSubscribed: json['isSubscribed'] ?? true,
      isMemberOnly: json['isMemberOnly'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'title': title,
        'isCampaign': isCampaign,
        'isSubscribed': isSubscribed,
        'isMemberOnly': isMemberOnly,
      };

  @override
  int get hashCode => this.hashCode;

  @override
  bool operator ==(covariant Category other) {
    // compare this to other
    return this.id == other.id;
  }

  static checkOtherParameters(Category a, Category b) {
    return a.name == b.name &&
        a.title == b.title &&
        a.isCampaign == b.isCampaign;
  }
}
