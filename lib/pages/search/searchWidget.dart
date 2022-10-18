import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/search/cubit.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/pages/search/searchListItem.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _textController = TextEditingController();
  final List<Record> _searchList = [];
  bool _isNeedToLoadMore = true;

  _searchByKeyword(String keyword) async {
    _searchList.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    context.read<SearchCubit>().searchByKeyword(keyword);
  }

  _searchNextPageByKeyword(String keyword) async {
    context.read<SearchCubit>().searchNextPageByKeyword(keyword);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
        builder: (BuildContext context, SearchState state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _keywordTextField(),
                ),
                const SizedBox(
                  width: 12,
                ),
                _searchButton(),
              ],
            ),
          ),
          Expanded(child: _buildSearchList(state)),
        ],
      );
    });
  }

  Widget _keywordTextField() {
    return Container(
      width: double.maxFinite,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.grey,
        ),
        child: TextField(
          controller: _textController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            hintText: "請輸入關鍵字",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          onSubmitted: (value) => _searchByKeyword(_textController.text),
        ),
      ),
    );
  }

  Widget _searchButton() {
    return InkWell(
      child: Container(
        color: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      onTap: () => _searchByKeyword(_textController.text),
    );
  }

  Widget _buildSearchList(SearchState state) {
    SearchStatus status = state.status;
    if (status == SearchStatus.searchLoadingError) {
      return Center(
        child: const Text(
          '搜尋發生錯誤，請稍後再試',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    if (status == SearchStatus.initial) {
      return Container();
    }

    if (status == SearchStatus.searchLoading) {
      return _loadingWidget();
    }

    if (status == SearchStatus.searchLoadingMoreFail) {
      Fluttertoast.showToast(
        msg: '發生錯誤，請稍後再試',
        gravity: ToastGravity.BOTTOM,
      );
    }

    if (status == SearchStatus.searchLoaded) {
      _searchList.addAll(state.searchStoryList!);
      _isNeedToLoadMore = _searchList.length < state.searchListTotal! &&
          _searchList.length < 100;
      if (_searchList.isEmpty) {
        return Center(
          child: Text(
            '找不到包含「${_textController.text}」的新聞',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16.0),
      itemCount: _searchList.length + 1,
      itemBuilder: (context, index) {
        if (index == _searchList.length) {
          if (_isNeedToLoadMore) {
            return VisibilityDetector(
              key: const Key('SearchLoadingMore'),
              child: _loadingWidget(),
              onVisibilityChanged: (info) {
                var percentage = info.visibleFraction * 100;
                if (percentage > 0.5 &&
                    state != SearchState.searchLoadingMore()) {
                  _searchNextPageByKeyword(_textController.text);
                }
              },
            );
          } else {
            return Container();
          }
        }

        return SearchListItem(record: _searchList[index]);
      },
    );
  }

  Widget _loadingWidget() => Center(
        child: CircularProgressIndicator.adaptive(),
      );
}
