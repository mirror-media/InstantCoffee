class Category {
  String? id;
  String? name;
  String? title;
  bool isCampaign;
  bool isSubscribed;
  bool isMemberOnly;

  Category({
    required this.id,
    required this.name,
    required this.title,
    this.isCampaign = false,
    this.isSubscribed = true,
    this.isMemberOnly = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['slug'],
      title: json['name'],
      isCampaign: json['isCampaign'] ?? false,
      isSubscribed: json['isSubscribed'] ?? true,
      isMemberOnly: json['isMemberOnly'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'slug': name,
        'title': title,
        'isCampaign': isCampaign,
        'isSubscribed': isSubscribed,
        'isMemberOnly': isMemberOnly,
      };

  @override
  int get hashCode => hashCode;

  @override
  bool operator ==(covariant Category other) {
    // compare this to other
    return id == other.id;
  }

  static checkOtherParameters(Category a, Category b) {
    return a.name == b.name &&
        a.title == b.title &&
        a.isCampaign == b.isCampaign;
  }

  static List<Map<dynamic, dynamic>> categoryListToJson(
      List<Category> categoryList) {
    List<Map> categoryMaps = [];
    for (Category category in categoryList) {
      categoryMaps.add(category.toJson());
    }
    return categoryMaps;
  }

  static List<Category> categoryListFromJson(List<dynamic> jsonList) {

    final a =jsonList.map<Category>((json) => Category.fromJson(json)).toList();
    return a;
  }

  static bool isMemberOnlyInCategoryList(List<Category> categoryList) {
    return categoryList.any((category) => category.isMemberOnly);
  }

  static List<String> getSubscriptionIdStringList(List<Category> categoryList) {
    List<String> idStringList = [];
    for (Category category in categoryList) {
      if (category.isSubscribed && category.id!=null) {
        idStringList.add(category.id!);
      }
    }
    return idStringList;
  }

  static int subscriptionCountInCategoryList(List<Category> categoryList) {
    int count = 0;
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].isSubscribed) {
        count++;
      }
    }

    return count;
  }

  static bool isTheSame(List<Category> categoryList, List<Category> other) {
    if (categoryList.length != other.length) {
      return false;
    }
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].id != other[i].id ||
          categoryList[i].name != other[i].name ||
          categoryList[i].title != other[i].title ||
          categoryList[i].isCampaign != other[i].isCampaign) {
        return false;
      }
    }

    return true;
  }

  static List<Category> getTheNewestCategoryList(
      {required List<Category>? localCategoryList,
      required List<Category> onlineCategoryList}) {
    if (localCategoryList == null) {
      return onlineCategoryList;
    }

    if (isTheSame(localCategoryList, onlineCategoryList)) {
      return localCategoryList;
    }

    if (onlineCategoryList.isNotEmpty) {
      List<Category> resultCategoryList = [];

      for (int i = 0; i < onlineCategoryList.length; i++) {
        Category onlineCategory = onlineCategoryList[i];
        bool onlineCategoryListIsExistedInLocalCategoryList = false;

        for (int j = 0; j < localCategoryList.length; j++) {
          Category localCategory = localCategoryList[j];

          // only check the Category id in operator '=='
          if (localCategory == onlineCategory) {
            onlineCategoryListIsExistedInLocalCategoryList = true;

            if (!Category.checkOtherParameters(localCategory, onlineCategory)) {
              resultCategoryList.add(Category(
                id: onlineCategory.id,
                name: onlineCategory.name,
                title: onlineCategory.title,
                isCampaign: onlineCategory.isCampaign,
                isSubscribed: localCategory.isSubscribed,
              ));
            } else {
              resultCategoryList.add(localCategory);
            }
          }
        }

        if (!onlineCategoryListIsExistedInLocalCategoryList) {
          resultCategoryList.add(onlineCategory);
        }
      }
      return resultCategoryList;
    }

    return localCategoryList;
  }
}


extension CategoryListToString on List<Category> {
  String toFormattedString() {
    return '[${map((obj) => '"${obj.name}"').join(",")}]';
  }
}
