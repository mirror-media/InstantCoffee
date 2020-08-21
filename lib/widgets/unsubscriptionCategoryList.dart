import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/blocs/personalPageBloc.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/categoryList.dart';

class UnsubscriptionCategoryList extends StatefulWidget {
  final StreamController<CategoryList> controller;
  final CategoryList categoryList;
  final PersonalPageBloc personalPageBloc;
  UnsubscriptionCategoryList({
    @required this.controller,
    @required this.categoryList,
    @required this.personalPageBloc,
  });
  
  @override
  _UnsubscriptionCategoryListState createState() => _UnsubscriptionCategoryListState();
}

class _UnsubscriptionCategoryListState extends State<UnsubscriptionCategoryList> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<CategoryList>(
      initialData: widget.categoryList,
      stream: widget.controller.stream,
      builder: (context, snapshot) {
        CategoryList unsubscriptionCategoryList = snapshot.data ;
        return ListView.builder(
          itemCount: unsubscriptionCategoryList.length,
          itemBuilder: (context, index) {
            if(unsubscriptionCategoryList[index].isSubscribed) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular((5.0)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appColor, width: 1),
                    borderRadius: BorderRadius.circular((5.0)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(unsubscriptionCategoryList[index].title),
                        SizedBox(width: 4.0),
                        Icon(
                          Icons.add_circle_outline,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  unsubscriptionCategoryList[index].isSubscribed =
                      !unsubscriptionCategoryList[index].isSubscribed;
                  
                  if(!widget.controller.isClosed) {
                    widget.controller.sink.add(unsubscriptionCategoryList);
                  }
                  
                  widget.personalPageBloc
                      .setCategoryListInStorage(unsubscriptionCategoryList);
                },
              ),
            );
          });
      },
    );
  }
}