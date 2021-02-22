import 'package:flutter/services.dart' show rootBundle;
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/sectionList.dart';
import 'dart:convert';

class SectionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SectionList> fetchSectionList({bool needMenu = true}) async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(env.baseConfig.sectionAPI, maxAge: sectionCacheDuration);

    SectionList sessions = SectionList.fromJson(jsonResponse["_items"]);
    if(needMenu) {
      String jsonFixed = await rootBundle.loadString('assets/data/menu.json');
      final fixedMenu = json.decode(jsonFixed);
      SectionList fixedSections = SectionList.fromJson(fixedMenu);
      fixedSections.addAll(sessions);

      return fixedSections;
    }

    sessions.deleteTheSectionByKey(env.baseConfig.listeningSectionKey);
    return sessions;
  }
}
