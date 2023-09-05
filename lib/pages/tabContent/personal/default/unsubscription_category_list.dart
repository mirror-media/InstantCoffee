import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/personalPage/category/bloc.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/category.dart';

class UnsubscriptionCategoryList extends StatefulWidget {
  final PersonalCategoryBloc personalCategoryBloc;
  const UnsubscriptionCategoryList({
    required this.personalCategoryBloc,
  });

  @override
  _UnsubscriptionCategoryListState createState() =>
      _UnsubscriptionCategoryListState();
}

class _UnsubscriptionCategoryListState
    extends State<UnsubscriptionCategoryList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.personalCategoryBloc,
      child: BlocBuilder<PersonalCategoryBloc, PersonalCategoryState>(
          builder: (BuildContext context, PersonalCategoryState state) {
        PersonalCategoryStatus status = state.status;
        if (status == PersonalCategoryStatus.initial) {
          context
              .read<PersonalCategoryBloc>()
              .add(FetchSubscribedCategoryList());
        }

        if (status == PersonalCategoryStatus.subscribedCategoryListLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (status == PersonalCategoryStatus.subscribedCategoryListLoaded) {
          List<Category> unsubscriptionCategoryList =
              state.subscribedCategoryList!;
          return unsubscriptionCategoryList.length -
                      Category.subscriptionCountInCategoryList(
                          unsubscriptionCategoryList) ==
                  0
              ? const Center(child: Text('全部已訂閱'))
              : ListView.builder(
                  itemCount: unsubscriptionCategoryList.length,
                  itemBuilder: (context, index) {
                    if (unsubscriptionCategoryList[index].isSubscribed) {
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
                                Text(unsubscriptionCategoryList[index].title ?? StringDefault.valueNullDefault),
                                const SizedBox(width: 4.0),
                                const Icon(
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
                              SetCategoryListInStorage(
                                  unsubscriptionCategoryList));
                        },
                      ),
                    );
                  });
        }

        if (status ==
            PersonalCategoryStatus.subscribedCategoryListLoadingError) {
          return SliverToBoxAdapter(child: Container());
        }

        return SliverToBoxAdapter(child: Container());
      }),
    );
  }
}
