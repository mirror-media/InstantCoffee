import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/storyPage/listening/cubit.dart';
import 'package:readr_app/blocs/storyPage/listening/states.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/date_time_format.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';
import 'package:readr_app/widgets/youtube_widget.dart';

class ListeningWidget extends StatefulWidget {
  const ListeningWidget({key}) : super(key: key);

  @override
  _ListeningWidget createState() {
    return _ListeningWidget();
  }
}

class _ListeningWidget extends State<ListeningWidget> with Logger {
  late bool _isPremium;

  @override
  void initState() {
    _isPremium = context.read<MemberBloc>().state.shouldShowPremiumUI;
    _fetchListeningStoryPageInfo(context.read<ListeningStoryCubit>().storySlug);
    super.initState();
  }

  _fetchListeningStoryPageInfo(String? storySlug) {
    if (storySlug == null) {
      return;
    }
    context.read<ListeningStoryCubit>().fetchListeningStoryPageInfo(storySlug);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<ListeningStoryCubit, ListeningStoryState>(
        builder: (context, state) {
      if (state is ListeningStoryError) {
        final error = state.error;
        debugLog('StoryError: ${error.message}');
        return Container();
      }

      if (state is ListeningStoryLoaded) {
        Listening listening = state.listening;
        List<Record> recordList = state.recordList;

        return _buildListeningStoryWidget(
          width,
          listening,
          recordList,
        );
      }

      // state is Init, Loading
      return _loadingWidget();
    });
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildListeningStoryWidget(
    double width,
    Listening listening,
    List<Record> recordList,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(children: [
                YoutubeWidget(
                  width: width,
                  youtubeId: listening.slug,
                ),
                const SizedBox(height: 16.0),
                if (isListeningWidgetAdsActivated && !_isPremium) ...[
                  MMAdBanner(
                    adUnitId: listening.storyAd!.hDUnitId,
                    adSize: AdSize.mediumRectangle,
                    isKeepAlive: true,
                  ),
                  const SizedBox(height: 16),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: _buildTitleAndDescription(listening),
                ),
                const SizedBox(height: 16.0),
                if (isListeningWidgetAdsActivated && !_isPremium) ...[
                  MMAdBanner(
                    adUnitId: listening.storyAd!.aT1UnitId,
                    adSize: AdSize.mediumRectangle,
                    isKeepAlive: true,
                  ),
                  const SizedBox(height: 16),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: _buildTheNewestVideos(width, recordList),
                ),
                if (isListeningWidgetAdsActivated && !_isPremium) ...[
                  MMAdBanner(
                    adUnitId: listening.storyAd!.fTUnitId,
                    adSize: AdSize.mediumRectangle,
                    isKeepAlive: true,
                  ),
                  const SizedBox(height: 16),
                ],
              ]),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: StatefulBuilder(builder: (context, setState) {
              return isListeningWidgetAdsActivated && !_isPremium
                  ? SizedBox(
                      height: AdSize.banner.height.toDouble(),
                      width: AdSize.banner.width.toDouble(),
                      child: MMAdBanner(
                        adUnitId: listening.storyAd!.stUnitId,
                        adSize: AdSize.banner,
                        isKeepAlive: true,
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ),
        ),
      ],
    );
  }

  _buildTitleAndDescription(Listening listening) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Column(
      children: [
        Text(
          listening.title,
          style: const TextStyle(
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              dateTimeFormat.changeYoutubeStringToDisplayString(
                  listening.publishedAt,
                  'yyyy/MM/dd HH:mm:ss',
                  articleDateTimePostfix),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          listening.description.split('-----')[0],
          style: const TextStyle(
            fontSize: 20,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  _buildTheNewestVideos(double width, List<Record> recordList) {
    double imageWidth = width - 32;
    double imageHeight = width / 16 * 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '最新影音',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appColor,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recordList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: [
                    CustomCachedNetworkImage(
                      height: imageHeight,
                      width: imageWidth,
                      imageUrl: recordList[index].photoUrl,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      recordList[index].title ?? StringDefault.valueNullDefault,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                onTap: () {
                  if (!_isPremium) {
                    AdHelper adHelper = AdHelper();
                    adHelper.checkToShowInterstitialAd();
                  }

                  _fetchListeningStoryPageInfo(recordList[index].slug);
                },
              );
            }),
      ],
    );
  }
}
