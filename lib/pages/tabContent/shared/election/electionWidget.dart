import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/election/election_cubit.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/models/election/municipality.dart';
import 'package:readr_app/pages/tabContent/shared/election/municipalityItem.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ElectionWidget extends StatefulWidget {
  ElectionWidget({Key? key}) : super(key: key);

  @override
  State<ElectionWidget> createState() => _ElectionWidgetState();
}

class _ElectionWidgetState extends State<ElectionWidget> {
  List<Municipality> municipalityList = [];
  late DateTime lastUpdateTime;
  final CarouselController carouselController = CarouselController();
  late final Timer autoUpdateTimer;
  int currentIndex = 0;
  RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
  late final String api;
  late final String lookmoreUrl;
  late final DateTime startShowTime;
  late final DateTime endShowTime;

  @override
  void initState() {
    if (remoteConfigHelper.election != null) {
      api = remoteConfigHelper.election!['api'];
      startShowTime = remoteConfigHelper.election!['startTime'];
      endShowTime = remoteConfigHelper.election!['endTime'];
      lookmoreUrl = remoteConfigHelper.election!['lookmoreUrl'];
      fetchMunicipalityData();
      autoUpdateTimer = Timer.periodic(
          const Duration(minutes: 1), (timer) => fetchMunicipalityData());
    }
    super.initState();
  }

  @override
  void dispose() {
    if (remoteConfigHelper.election != null) autoUpdateTimer.cancel();
    super.dispose();
  }

  void fetchMunicipalityData() {
    var now = DateTime.now();
    if (now.isBefore(startShowTime) || now.isAfter(endShowTime)) {
      context.read<ElectionCubit>().hideWidget();
    } else {
      context.read<ElectionCubit>().fetchMunicipalityData(api);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (remoteConfigHelper.election == null) {
      return const SizedBox();
    }
    return BlocBuilder<ElectionCubit, ElectionState>(
      builder: (context, state) {
        if (state is HideWidget) {
          return const SizedBox();
        }

        if (state is ElectionDataLoaded) {
          municipalityList = state.municipalityList;
          lastUpdateTime = state.lastUpdateTime;
        }

        if (municipalityList.isEmpty) {
          return const SizedBox();
        }

        List<Widget> items = [];
        for (var item in municipalityList) {
          items.add(MunicipalityItem(item));
        }

        return Container(
          color: const Color.fromRGBO(243, 245, 247, 1),
          padding: const EdgeInsets.fromLTRB(53, 30, 54, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '六都市長開票進度',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(29, 159, 184, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => carouselController.previousPage(),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        CupertinoIcons.arrowtriangle_left_fill,
                        size: 20,
                        color: Color.fromRGBO(35, 79, 116, 1),
                      ),
                    ),
                  ),
                  Text(
                    municipalityList[currentIndex].name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(5, 79, 119, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => carouselController.nextPage(),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        CupertinoIcons.arrowtriangle_right_fill,
                        size: 20,
                        color: Color.fromRGBO(35, 79, 116, 1),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black12,
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 3),
                  height: 207,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: items,
                carouselController: carouselController,
              ),
              Text(
                '最後更新時間：${DateFormat('yyyy/MM/dd HH:mm').format(lastUpdateTime)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(155, 155, 155, 1),
                ),
              ),
              const Text(
                '資料來源：中央選舉委員會',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(155, 155, 155, 1),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => launchUrlString(lookmoreUrl),
                  child: const Text(
                    '完整開票內容',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromRGBO(74, 74, 74, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
