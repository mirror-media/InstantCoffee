import 'package:flutter/services.dart' show rootBundle;
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/sectionList.dart';
import '../helpers/constants.dart';
import 'dart:convert';

class SectionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SectionList> fetchSectionList() async {
    final jsonResponse = await _helper.getByUrl(sectionAPI);

    SectionList sessions = SectionList.fromJson(jsonResponse["_items"]);
    String jsonFixed = await rootBundle.loadString('assets/data/menu.json');
    final fixedMenu = json.decode(jsonFixed);
    SectionList fixedSections = new SectionList.fromJson(fixedMenu);
    fixedSections.addAll(sessions);

    return fixedSections;
  }
}
