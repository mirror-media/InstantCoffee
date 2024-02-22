import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/states.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/models/contact/city.dart';
import 'package:readr_app/models/contact/country.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/city_picker.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/country_picker.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/district_picker.dart';
import 'package:readr_app/widgets/logger.dart';
class EditMemberContactInfoWidget extends StatefulWidget {
  @override
  _EditMemberContactInfoWidgetState createState() =>
      _EditMemberContactInfoWidgetState();
}

class _EditMemberContactInfoWidgetState
    extends State<EditMemberContactInfoWidget> with Logger {
  List<Country>? _countryList;
  List<City>? _cityList;

  @override
  void initState() {
    fetchCountryListAndCityListFromJson();
    super.initState();
  }

  Future<void> fetchCountryListAndCityListFromJson() async {
    String jsonCountries =
        await rootBundle.loadString('packages/constants/countries.json');
    _countryList = Country.parseCountryList(jsonCountries);

    String jsonCities =
        await rootBundle.loadString('packages/constants/taiwan-districts.json');
    _cityList = City.parseCityList(jsonCities);

    setState(() {});
    _fetchMemberContactInfo();
  }

  _fetchMemberContactInfo() {
    context.read<EditMemberContactInfoBloc>().add(FetchMemberContactInfo());
  }

  _updateMemberContactInfo(Member member) {
    context
        .read<EditMemberContactInfoBloc>()
        .add(UpdateMemberContactInfo(editMember: member));
  }

  @override
  Widget build(BuildContext context) {
    if (_countryList == null || _cityList == null) {
      return Scaffold(
        appBar: _buildBar(context, null),
        body: _loadingWidget(),
      );
    }

    return BlocBuilder<EditMemberContactInfoBloc, EditMemberContactInfoState>(
        builder: (BuildContext context, EditMemberContactInfoState state) {
      if (state is MemberLoadedError) {
        final error = state.error;
        debugLog('MemberLoadedError: ${error.message}');
        return Scaffold(
          appBar: _buildBar(context, null),
          body: Container(),
        );
      }

      if (state is MemberLoaded) {
        Member member = state.member;
        return Scaffold(
          appBar: _buildBar(context, member),
          body: _contactInfoForm(member),
        );
      }

      if (state is SavingLoading) {
        Member member = state.member;

        return Scaffold(
          appBar: _buildBar(context, member, isSaveLoading: true),
          body: _contactInfoForm(member),
        );
      }

      // state is Init, Loading
      return Scaffold(
        appBar: _buildBar(context, null),
        body: _loadingWidget(),
      );
    });
  }

  PreferredSizeWidget _buildBar(BuildContext context, Member? member,
      {bool isSaveLoading = false}) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColor,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: const Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Text('修改聯絡資訊'),
          if (!isSaveLoading)
            TextButton(
              onPressed: member == null
                  ? null
                  : () {
                      _updateMemberContactInfo(member);
                      debugLog('save');
                    },
              child: Text(
                '儲存',
                style: TextStyle(
                    fontSize: 16,
                    color: member == null ? Colors.grey : Colors.white),
              ),
            ),
          if (isSaveLoading)
            const TextButton(
              onPressed: null,
              child: SpinKitRipple(
                color: Colors.white,
                size: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _contactInfoForm(Member member) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _phoneTextField(member),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: CountryPicker(
            member: member,
            countryList: _countryList!,
          ),
        ),
        if (member.contactAddress.country == '臺灣') ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CityPicker(
                    member: member,
                    cityList: _cityList!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: DistrictPicker(
                    member: member,
                    cityList: _cityList!,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _addressTextField(member),
        ),
      ],
    );
  }

  Widget _phoneTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              '手機',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          TextFormField(
            initialValue: member.phoneNumber,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              hintText: '0999999999',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            onChanged: (value) {
              member.phoneNumber = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _addressTextField(Member member) {
    return Container(
      color: Colors.grey[300],
      child: TextFormField(
        initialValue: member.contactAddress.address,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          hintText: '自填地址',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
        ),
        onChanged: (value) {
          member.contactAddress.address = value;
        },
      ),
    );
  }
}
