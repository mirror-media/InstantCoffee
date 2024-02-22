import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/editorChoice/cubit.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/pages/tabContent/news/widget/live_stream_widget.dart';
import 'package:readr_app/pages/tabContent/shared/premium_list_item.dart';
import 'package:readr_app/pages/tabContent/shared/the_first_item.dart';
import 'package:readr_app/pages/tabContent/shared/topic_block.dart';
import 'package:readr_app/services/editor_choice_service.dart';
import 'package:readr_app/widgets/editor_choice_carousel.dart';
import 'package:readr_app/widgets/error_stateless_widget.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/widgets/newsMarquee/news_marquee_persistent_header_delegate.dart';
import 'package:real_time_invoice_widget/real_time_invoice/real_time_invoice_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  final bool needCarousel;

  const PremiumTabContent({
    Key? key,
    required this.section,
    required this.scrollController,
    this.needCarousel = false,
  }) : super(key: key);

  @override
  _PremiumTabContentState createState() => _PremiumTabContentState();
}

class _PremiumTabContentState extends State<PremiumTabContent> with Logger {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  final HomeController controller = Get.find();

  _fetchFirstRecordList() {
    context.read<TabContentBloc>().add(FetchFirstRecordList(
        sectionName: widget.section.name ?? StringDefault.valueNullDefault,
        sectionKey: widget.section.key ?? StringDefault.valueNullDefault,
        sectionType: widget.section.type ?? StringDefault.valueNullDefault));
  }

  _fetchNextPageRecordList() {
    context.read<TabContentBloc>().add(FetchNextPageRecordList(
        sectionName: widget.section.name ?? StringDefault.valueNullDefault,
        isLatest: widget.section.key == Environment().config.latestSectionKey));
  }

  @override
  void initState() {
    _fetchFirstRecordList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchFirstRecordList();
      },
      child: BlocBuilder<TabContentBloc, TabContentState>(
          builder: (BuildContext context, TabContentState state) {
        switch (state.status) {
          case TabContentStatus.loadingError:
            final error = state.errorMessages;
            debugLog('TabContent: ${error.message}');
            return ErrorStatelessWidget(
              errorMessage: error.message,
              onRetryPressed: () => _fetchFirstRecordList(),
            );
          case TabContentStatus.loaded:
          case TabContentStatus.loadingMore:
            List<Record> recordList = state.recordList!;

            return _buildTheRecordList(recordList,
                hasNextPage: state.hasNextPage!,
                isLoadingMore: state.status == TabContentStatus.loadingMore);
          default:
            // state is Init, Loading
            return _loadingWidget();
        }
      }),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEditorChoiceList() {
    return BlocProvider(
      create: (BuildContext context) =>
          EditorChoiceCubit(editorChoiceRepos: EditorChoiceService()),
      child: BlocBuilder<EditorChoiceCubit, EditorChoiceState>(
          builder: (context, state) {
        if (state.status == EditorChoiceStatus.initial) {
          context.read<EditorChoiceCubit>().fetchEditorChoiceRecordList();
        } else if (state.status == EditorChoiceStatus.loaded) {
          List<Record> editorChoiceList = state.editorChoiceList!;

          return EditorChoiceCarousel(
            editorChoiceList: editorChoiceList,
            aspectRatio: 16 / 10,
          );
        } else if (state.status == EditorChoiceStatus.error) {
          debugLog('NewsMarquee error: ${state.errorMessages}');
        }

        return Container();
      }),
    );
  }

  Widget _buildTheRecordList(
    List<Record> recordList, {
    bool hasNextPage = true,
    bool isLoadingMore = false,
  }) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (!_remoteConfigHelper.isNewsMarqueePin)
          SliverPersistentHeader(
            delegate: NewsMarqueePersistentHeaderDelegate(),
            floating: true,
          ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (hasNextPage &&
                !isLoadingMore &&
                index == recordList.length - 1) {
              _fetchNextPageRecordList();
            }
            if (index == 0) {
              if (widget.needCarousel) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_remoteConfigHelper.isElectionShow) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27),
                          child: RealTimeInvoiceWidget(
                              isPackage: true,
                              getMoreButtonClick: () async {
                                if (!await launchUrl(Uri.parse(
                                    Environment()
                                    .config
                                    .electionGetMoreLink))) {
                                  throw Exception('Could not launch');
                                }
                              }, width: Get.width-54,),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                      _buildEditorChoiceList(),
                      if (widget.section.key ==
                          Environment().config.latestSectionKey) ...[
                        TopicBlock(
                          isPremium: true,
                        ),
                        const SizedBox(height: 24),
                        Obx(() {
                          final liveStreamModel =
                              controller.rxLiveStreamModel.value;
                          final ytController = controller.ytStreamController;
                          return liveStreamModel != null && ytController != null
                              ? LiveStreamWidget(
                                  title: liveStreamModel.name ??
                                      StringDefault.valueNullDefault,
                                  ytPlayer: ytController,
                                )
                              : Container();
                        }),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                      _buildTagText(),
                      Padding(
                          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                          child: PremiumListItem(
                            record: recordList[index],
                            onTap: () =>
                                _navigateToStoryPage(recordList[index]),
                          )),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ]);
              }

              return TheFirstItem(
                record: recordList[index],
                onTap: () => _navigateToStoryPage(recordList[index]),
              );
            }

            return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                    child: PremiumListItem(
                      record: recordList[index],
                      onTap: () => _navigateToStoryPage(recordList[index]),
                    )),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                if (index == recordList.length - 1 && isLoadingMore)
                  _loadMoreWidget(),
              ],
            );
          }, childCount: recordList.length),
        ),
      ],
    );
  }

  Widget _loadMoreWidget() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _buildTagText() {
    return Container(
      color: appColor,
      child: const Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Center(
          child: Text(
            '最新文章',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _navigateToStoryPage(Record record) {
    if (record.slug == null) {
      return;
    }
    if (record.isExternal) {
      RouteGenerator.navigateToExternalStory(record.slug!, isPremiumMode: true);
    } else {
      RouteGenerator.navigateToStory(
        record.slug!,
        isMemberCheck: record.isMemberCheck,
        url: record.url,
      );
    }
  }
}
