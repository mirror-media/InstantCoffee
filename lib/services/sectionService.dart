import 'package:flutter/services.dart' show rootBundle;
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/section.dart';
import 'dart:convert';

class SectionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Section>> fetchSectionList({bool needMenu = true}) async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(Environment().config.sectionApi, maxAge: sectionCacheDuration);

    List<Section> sectionList = Section.sectionListFromJson(jsonResponse["_items"]);
    if(needMenu) {
      String jsonFixed = await rootBundle.loadString('assets/data/menu.json');
      final fixedMenu = json.decode(jsonFixed);
      List<Section> fixedSections = Section.sectionListFromJson(fixedMenu);
      fixedSections.addAll(sectionList);

      return fixedSections;
    }

    sectionList.removeWhere((section) => section.key == Environment().config.listeningSectionKey);
    return sectionList;
  }
}
