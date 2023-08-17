import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/models/section.dart';
import 'dart:convert';

abstract class SectionRepos {
  Future<List<Section>> fetchSectionList({bool needMenu = true});
}

class SectionService implements SectionRepos {
  ApiBaseHelper helper = ApiBaseHelper();
  final ArticlesApiProvider articlesApiProvider = Get.find();

  @override
  Future<List<Section>> fetchSectionList({bool needMenu = true}) async {
    final jsonResponse = await helper.getByCacheAndAutoCache(
        Environment().config.sectionApi,
        maxAge: sectionCacheDuration);

    List<Section> sectionList = await articlesApiProvider.getSectionList();
    if (needMenu) {
      String jsonFixed = await rootBundle.loadString('assets/data/menu.json');
      final fixedMenu = json.decode(jsonFixed);
      List<Section> fixedSections = Section.sectionListFromJson(fixedMenu);
      fixedSections.addAll(sectionList);

      return fixedSections;
    }

    sectionList.removeWhere(
        (section) => section.key == Environment().config.listeningSectionKey);
    return sectionList;
  }
}
