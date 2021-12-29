import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/tagPage/cubit.dart';
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
    _fetchStoryListByTagId();
    super.initState();
  }

  _fetchStoryListByTagId() {
    context.read<TagPageCubit>().fetchTagStoryList(widget.tag.id);
  }

  _fetchNextPage() async {
    context.read<TagPageCubit>().fetchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagPageCubit, TagPageState>(
        builder: (BuildContext context, TagPageState state) {
      if (state is TagPageError) {
        final error = state.error;
        print('tagRecordListError: ${error.message}');
        if (loadingMore) {
          _fetchNextPage();
        } else {
          return error.renderWidget(
                onPressed: () => _fetchStoryListByTagId());
        }
      }

      if (state is TagPageLoadingNextPage) {
        loadingMore = true;
        return _buildList(_tagRecordList);
      }

      if (state is TagPageLoadNextPageFailed) {
        _tagRecordList = state.tagStoryList;
        loadingMore = true;
        _fetchNextPage();
        return _buildList(_tagRecordList);
      }

      if (state is TagPageLoaded) {
        _tagRecordList = state.tagStoryList;
        loadingMore = false;
        return _buildList(_tagRecordList);
      }
      // state is Init, loading, or other
      return Center(
        child: Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(),
      );
    });
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
          if (!loadingMore) _fetchNextPage();
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
        RouteGenerator.navigateToStory(
          record.slug,
          isMemberCheck: record.isMemberCheck, 
          isMemberContent: record.isMemberContent,
        );
      },
    );
  }
}
