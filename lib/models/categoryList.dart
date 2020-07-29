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

    CategoryList objects = CategoryList();
    List parseList = parsedJson.map((i) => Category.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory CategoryList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return CategoryList.fromJson(jsonData);
  }
}
