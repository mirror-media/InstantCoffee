import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../helpers/Constants.dart';
import 'dart:convert';
import 'SectionList.dart';
import 'Section.dart';

class SectionService {
  Future<String> _fetchSectionData() async {
    final response = await http.get(sectionAPI);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "{'status': 'error', 'message': 'API return error'}";
    }
  }

  Future<SectionList> loadSections() async {
    String jsonParsed = await _fetchSectionData();
    final jsonObject = json.decode(jsonParsed);
    SectionList sessions = new SectionList.fromJson(jsonObject["_items"]);
    String jsonFixed = await rootBundle.loadString('assets/data/menu.json');
    final fixedMenu = json.decode(jsonFixed);
    SectionList fixedSections = new SectionList.fromJson(fixedMenu);
    //SectionList fixedSections = new SectionList();
    for (Section sec in sessions.sections) {
      fixedSections.sections.add(sec);
    }

    return fixedSections;
  }
}
