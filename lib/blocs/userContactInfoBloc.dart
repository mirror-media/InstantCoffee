import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/cityList.dart';
import 'package:readr_app/models/contactAddress.dart';
import 'package:readr_app/models/countryList.dart';
import 'package:readr_app/models/userData.dart';

class UserContactInfoBloc {
  UserData _editUserData;
  CountryList _countryList;
  CityList _cityList;
  UserData get editUserData => _editUserData;
  CountryList get countryList => _countryList;
  CityList get cityList => _cityList;

  StreamController _userDataController;
  StreamSink<ApiResponse<UserData>> get userDataSink => _userDataController.sink;
  Stream<ApiResponse<UserData>> get userDataStream => _userDataController.stream;

  UserContactInfoBloc(UserData userData) {
    _countryList = CountryList();
    _cityList = CityList();

    _userDataController = StreamController<ApiResponse<UserData>>();
    initialize(userData);
  }

  sinkToAdd(ApiResponse<UserData> value) {
    if (!_userDataController.isClosed) {
      userDataSink.add(value);
    }
  }

  initialize(UserData userData) async {
    sinkToAdd(ApiResponse.loading('Fetching Story page'));

    try {
      _editUserData = userData;
      if(_editUserData.contactAddress == null) {
        _editUserData.contactAddress = ContactAddress();
      }
      await fetchCountryListAndCityListFromJson();

      sinkToAdd(ApiResponse.completed(_editUserData));
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
    _userDataController?.close();
  }
}
