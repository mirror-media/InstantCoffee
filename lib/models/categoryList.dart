import 'dart:convert';

import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/customizedList.dart';

class CategoryList extends CustomizedList<Category> {
  // constructor
  CategoryList();

  factory CategoryList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    CategoryList categories = CategoryList();
    List parseList = parsedJson.map((i) => Category.fromJson(i)).toList();
    parseList.forEach((element) {
      categories.add(element);
    });

    return categories;
  }

  factory CategoryList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return CategoryList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> categoryMaps = List();
    if (l == null) {
      return null;
    }

    for (Category category in l) {
      categoryMaps.add(category.toJson());
    }
    return categoryMaps;
  }

  List<String> get getSubscriptionIdStringList {
    List<String> idStringList = List<String>();
    if (l == null) {
      return null;
    }

    for (Category category in l) {
      if (category.isSubscribed) {
        idStringList.add(category.id);
      }
    }
    return idStringList;
  }

  int get subscriptionCount {
    int count = 0;
    for(int i=0; i<l.length; i++) {
      if(l[i].isSubscribed) {
        count ++;
      }
    }
    
    return count;
  }

  bool isTheSame(CategoryList other) {
    if(l.length != other.length) {
      return false;
    }
    for(int i=0; i<l.length; i++) {
      if(l[i].id != other[i].id || 
        l[i].name != other[i].name ||
        l[i].title != other[i].title ||
        l[i].isCampaign != other[i].isCampaign
      ) {
        return false;
      }
    }

    return true;
  }

  bool isMemberOnly() {
    for(int i=0; i<l.length; i++) {
      if(l[i].isMemberOnly) {
        return true;
      }
    }

    return false;
  }

  // static methods
  static CategoryList getTheNewestCategoryList(
      {CategoryList localCategoryList, CategoryList onlineCategoryList}) {
    if (localCategoryList == null) {
      return onlineCategoryList;
    }

    if(localCategoryList.isTheSame(onlineCategoryList)) {
      return localCategoryList;
    }

    if (onlineCategoryList.length != 0) {
      CategoryList resultCategoryList = CategoryList();

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
