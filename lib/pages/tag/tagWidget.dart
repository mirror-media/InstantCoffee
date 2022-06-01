import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/tagPage/cubit.dart';
import 'package:readr_app/blocs/tagPage/states.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/tag.dart';

class TagWidget extends StatefulWidget {
  final Tag tag;
  const TagWidget(this.tag);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
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
      TagPageStatus status = state.status;
      if (status == TagPageStatus.error) {
        final error = state.errorMessages;
        print('TagRecordListError: $error');
        return error.renderWidget(onPressed: () => _fetchStoryListByTagId());
      }

      if (status == TagPageStatus.loaded) {
        return _buildList(
          state.tagStoryList!,
          state.tagListTotal!,
        );
      }

      if (status == TagPageStatus.loadingMore) {
        return _buildList(
          state.tagStoryList!,
          state.tagListTotal!,
          isLoadingMore: true,
        );
      }

      if (status == TagPageStatus.loadingMoreFail) {
        final error = state.errorMessages;
        print('TagRecordListLoadingMoreFail: $error');
        _fetchNextPage();
        return _buildList(
          state.tagStoryList!,
          state.tagListTotal!,
          isLoadingMore: true,
        );
      }

      // state is Init, loading, or other
      return Center(
        child: Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(),
      );
    });
  }

  Widget _buildList(
    List<Record> tagRecordList,
    int totalTagList, {
    bool isLoadingMore = false,
  }) {
    bool isAll = tagRecordList.length == totalTagList;

    return ListView.separated(
      itemCount: tagRecordList.length + 1,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      separatorBuilder: (context, index) {
        if (index == tagRecordList.length - 1) {
          return const SizedBox(
            height: 24,
          );
        }
        return const Divider(
          height: 40,
          thickness: 1,
          color: Colors.black12,
        );
      },
      itemBuilder: (context, index) {
        if (index == tagRecordList.length) {
          if (!isLoadingMore) {
            if (!isAll) {
              _fetchNextPage();
            }
            return Container(
              padding: const EdgeInsets.only(bottom: 24),
            );
          }

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
          url: record.url,
        );
      },
    );
  }
}
