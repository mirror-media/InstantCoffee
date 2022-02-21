import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/personalPage/category/bloc.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/category.dart';

class UnsubscriptionCategoryList extends StatefulWidget {  
  final PersonalCategoryBloc personalCategoryBloc;
  UnsubscriptionCategoryList({
    required this.personalCategoryBloc,
  });

  @override
  _UnsubscriptionCategoryListState createState() => _UnsubscriptionCategoryListState();
}

class _UnsubscriptionCategoryListState extends State<UnsubscriptionCategoryList> {
  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: widget.personalCategoryBloc,
      child: BlocBuilder<PersonalCategoryBloc, PersonalCategoryState>(
        builder: (BuildContext context, PersonalCategoryState state) {
          PersonalCategoryStatus status = state.status;
          if(status == PersonalCategoryStatus.initial) {
            context.read<PersonalCategoryBloc>().add(FetchSubscribedCategoryList());
          }

          if(status == PersonalCategoryStatus.subscribedCategoryListLoading) {
            return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if(status == PersonalCategoryStatus.subscribedCategoryListLoaded) {
            List<Category> unsubscriptionCategoryList = state.subscribedCategoryList!;
            return unsubscriptionCategoryList.length - 
                Category.subscriptionCountInCategoryList(unsubscriptionCategoryList) 
                == 0
            ? Center(child: Text('全部已訂閱'))
            : ListView.builder(
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
                        context.read<PersonalCategoryBloc>().add(
                          SetCategoryListInStorage(unsubscriptionCategoryList)
                        );
                      },
                    ),
                  );
                });
          }

          if(status == PersonalCategoryStatus.subscribedCategoryListLoadingError) {
            return SliverToBoxAdapter(
              child: Text('error')
            );      
          }

          return SliverToBoxAdapter(
            child: Container()
          );
        }
      ),
    );
  }
}