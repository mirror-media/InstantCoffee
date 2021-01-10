import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/cityList.dart';
import 'package:readr_app/models/contactAddress.dart';
import 'package:readr_app/models/countryList.dart';
import 'package:readr_app/models/member.dart';

class MemberContactInfoBloc {
  Member _editMember;
  CountryList _countryList;
  CityList _cityList;
  Member get editMember => _editMember;
  CountryList get countryList => _countryList;
  CityList get cityList => _cityList;

  StreamController _memberController;
  StreamSink<ApiResponse<Member>> get memberSink => _memberController.sink;
  Stream<ApiResponse<Member>> get memberStream => _memberController.stream;

  MemberContactInfoBloc(Member member) {
    _countryList = CountryList();
    _cityList = CityList();

    _memberController = StreamController<ApiResponse<Member>>();
    initialize(member);
  }

  sinkToAdd(ApiResponse<Member> value) {
    if (!_memberController.isClosed) {
      memberSink.add(value);
    }
  }

  initialize(Member member) async {
    sinkToAdd(ApiResponse.loading('Fetching Story page'));

    try {
      _editMember = member;
      if(_editMember.contactAddress == null) {
        _editMember.contactAddress = ContactAddress();
      }
      await fetchCountryListAndCityListFromJson();

      sinkToAdd(ApiResponse.completed(_editMember));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<void> fetchCountryListAndCityListFromJson() async{
    String jsonCountries = await rootBundle.loadString('assets/data/countries.json');
    final jsonCountryList = json.decode(jsonCountries);
    _countryList = CountryList.fromJson(jsonCountryList);

    String jsonCities = await rootBundle.loadString('assets/data/taiwanDistricts.json');
    final jsonCityList = json.decode(jsonCities);
    _cityList = CityList.fromJson(jsonCityList);
  }

  dispose() {
    _memberController?.close();
  }
}
