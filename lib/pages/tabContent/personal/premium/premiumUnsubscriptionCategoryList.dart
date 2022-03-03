import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/personalPage/category/bloc.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/category.dart';

class PremiumUnsubscriptionCategoryList extends StatefulWidget {  
  final PersonalCategoryBloc personalCategoryBloc;
  PremiumUnsubscriptionCategoryList({
    required this.personalCategoryBloc,
  });

  @override
  _PremiumUnsubscriptionCategoryListState createState() => _PremiumUnsubscriptionCategoryListState();
}

class _PremiumUnsubscriptionCategoryListState extends State<PremiumUnsubscriptionCategoryList> {
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

            return ListView(
              children: [
                Wrap(
                  children: [
                    for (int index=0; index<unsubscriptionCategoryList.length; index++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: unsubscriptionCategoryList[index].isSubscribed
                        ? _buildSubscribedCategoryChip(
                            unsubscriptionCategoryList[index].title,
                            () {
                              unsubscriptionCategoryList[index].isSubscribed =
                                  !unsubscriptionCategoryList[index].isSubscribed;
                              context.read<PersonalCategoryBloc>().add(
                                SetCategoryListInStorage(unsubscriptionCategoryList)
                              );
                            },
                          )
                        : _buildUnSubscribedCategoryChip(
                            unsubscriptionCategoryList[index].title,
                            () {
                              unsubscriptionCategoryList[index].isSubscribed =
                                  !unsubscriptionCategoryList[index].isSubscribed;
                              context.read<PersonalCategoryBloc>().add(
                                SetCategoryListInStorage(unsubscriptionCategoryList)
                              );
                            },
                          )
                      )
                  ],
                ),
              ],
            );
          }

          if(status == PersonalCategoryStatus.subscribedCategoryListLoadingError) {
            return SliverToBoxAdapter(
              child: Container()
            );      
          }

          return SliverToBoxAdapter(
            child: Container()
          );
        }
      ),
    );
  }

  Widget _buildSubscribedCategoryChip(String title, GestureTapCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular((10.0)),
      child: Container(
        decoration: BoxDecoration(
          color: appColor,
          border: Border.all(color: appColor, width: 1),
          borderRadius: BorderRadius.circular((10.0)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      onTap: onTap
    );
  }

  Widget _buildUnSubscribedCategoryChip(String title, GestureTapCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular((10.0)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: appColor, width: 1),
          borderRadius: BorderRadius.circular((10.0)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
          child: Text(
            title,
            style: TextStyle(color: appColor)
          ),
        ),
      ),
      onTap: onTap
    );
  }
}