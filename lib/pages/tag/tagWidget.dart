import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/tag.dart';

class TagWidget extends StatefulWidget {
  final Tag tag;
  const TagWidget(this.tag);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  bool loadingMore = false;
  RecordList _tagRecordList = RecordList();

  @override
  void initState() {
    // _fetchStoryListByTagSlug();
    _buildMockData();
    super.initState();
  }

  // _fetchStoryListByTagSlug() {
  //   context
  //       .read<tagRecordListBloc>()
  //       .add(FetchStoryListByTagSlug(widget.tag.slug));
  // }

  // _fetchNextPageByTagSlug() async {
  //   context
  //       .read<tagRecordListBloc>()
  //       .add(FetchNextPageByTagSlug(widget.tag.slug));
  // }

  void _buildMockData(){
    Record data1 = Record(
        title: 'LISA 示範情人節穿搭 CELINE 七夕膠囊系列好火紅', 
        photoUrl: 'https://storage.googleapis.com/mirrormedia-files/assets/images/20210317185015-013b905320686dea9abf085902f36118.png',
        slug: '',
        publishedDate: '',
        isMemberCheck: false,
        );
    Record data2 = Record(
        title: '【搞懂特別股】股神也押寶大賺　特別股成投資市場新寵', 
        photoUrl: 'https://storage.googleapis.com/mirrormedia-files/assets/images/20210310161729-e29776bb6fd1ab3869439e41c8cb3e0e-mobile.jpg',
        slug: '',
        publishedDate: '',
        isMemberCheck: false,
        );
    for(int i = 0; i < 5;i++){
      _tagRecordList.add(data1);
      _tagRecordList.add(data2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(_tagRecordList);

    // return BlocBuilder<tagRecordListBloc, tagRecordListState>(
    //     builder: (BuildContext context, tagRecordListState state) {
    //   if (state.status == tagRecordListStatus.error) {
    //     final error = state.error;
    //     print('tagRecordListError: ${error.message}');
    //     if (loadingMore) {
    //       _fetchNextPageByTagSlug();
    //     } else {
    //       if (error is NoInternetException) {
    //         return error.renderWidget(
    //             onPressed: () => _fetchNextPageByTagSlug());
    //       }

    //       return error.renderWidget();
    //     }
    //   }

    //   if (state.status == tagRecordListStatus.loadingMore) {
    //     _tagRecordList = state.tagRecordList!;
    //     loadingMore = true;
    //     return _buildList(_tagRecordList);
    //   }

    //   if (state.status == tagRecordListStatus.loadingMoreFail) {
    //     _tagRecordList = state.tagRecordList!;
    //     loadingMore = true;
    //     _fetchNextPageByTagSlug();
    //     return _buildList(_tagRecordList);
    //   }

    //   if (state.status == tagRecordListStatus.loaded) {
    //     _tagRecordList = state.tagRecordList!;
    //     loadingMore = false;
    //     return _buildList(_tagRecordList);
    //   }
    //   // state is Init, loading, or other
    //   return Center(
    //     child: Platform.isAndroid
    //         ? const CircularProgressIndicator()
    //         : const CupertinoActivityIndicator(),
    //   );
    // });
  }

  Widget _buildList(RecordList tagRecordList) {
    bool isAll = false;
    if (tagRecordList.length == tagRecordList.allRecordCount) {
      isAll = true;
    }
    return ListView.separated(
      itemCount: tagRecordList.length + 1,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      separatorBuilder: (context, index){
        if(index == tagRecordList.length - 1){
          return const SizedBox(height: 24,);
        }
        return const Divider(
          height: 40,
          thickness: 1,
          color: Colors.black12,
        );
      },
      itemBuilder: (context, index) {
        if (index == tagRecordList.length) {
          if (isAll) {
            return Container(
              padding: const EdgeInsets.only(bottom: 24),
            );
          }
          // if (!loadingMore) _fetchNextPageByTagSlug();
          return Center(
            child: Platform.isAndroid
                ? const CircularProgressIndicator()
                : const CupertinoActivityIndicator(),
          );
        }
        return _buildListItem(tagRecordList[index]);
      },
    );
  }

  Widget _buildListItem(Record record) {
    double imageWidth = 84;
    double imageHeight = imageWidth;

    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              record.title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          CachedNetworkImage(
            height: imageHeight,
            width: imageWidth,
            imageUrl: record.photoUrl,
            placeholder: (context, url) => Container(
              height: imageHeight,
              width: imageWidth,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: imageHeight,
              width: imageWidth,
              color: Colors.grey,
              child: Icon(Icons.error),
            ),
            fit: BoxFit.cover,
          ),
        ],
      ),
      onTap: () {
        // RouteGenerator.navigateToStory(record.slug);
      },
    );
  }
}
