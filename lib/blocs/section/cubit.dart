import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/section/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/services/sectionService.dart';

class SectionCubit extends Cubit<SectionState> {
  final SectionRepos sectionRepos;
  SectionCubit({required this.sectionRepos}) 
      : super(SectionState.init());
  
  fetchSectionList() async {
    print('Fetch section list');
    emit(SectionState.loading());

    try {
      List<Section> sectionList = await sectionRepos.fetchSectionList();
      
      String sectionAdJsonFileLocation = Platform.isIOS
      ? Environment().config.iOSSectionAdJsonLocation
      : Environment().config.androidSectionAdJsonLocation;

      String sectionAdString = await rootBundle.loadString(sectionAdJsonFileLocation);
      final sectionAdMaps = json.decode(sectionAdString);
      for(int i=0; i<sectionList.length; i++) {
        if(sectionAdMaps[sectionList[i].key] != null) {
          sectionList[i].sectionAd = SectionAd.fromJson(sectionAdMaps[sectionList[i].key]);
        } else {
          sectionList[i].sectionAd = SectionAd.fromJson(sectionAdMaps['other']);
        }
      }

      emit(SectionState.loaded(sectionList: sectionList));
    } catch (e) {
      emit(SectionState.error(errorMessages: e));
      print(e);
    }
  }
}