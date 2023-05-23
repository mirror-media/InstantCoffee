import 'package:readr_app/models/category.dart';

enum PersonalCategoryStatus {
  initial,
  subscribedCategoryListLoading,
  subscribedCategoryListLoaded,
  subscribedCategoryListLoadingError,
}

class PersonalCategoryState {
  final PersonalCategoryStatus status;
  final List<Category>? subscribedCategoryList;
  final dynamic errorMessages;

  const PersonalCategoryState({
    required this.status,
    this.subscribedCategoryList,
    this.errorMessages,
  });

  factory PersonalCategoryState.init() {
    return const PersonalCategoryState(status: PersonalCategoryStatus.initial);
  }

  factory PersonalCategoryState.subscribedCategoryListLoading() {
    return const PersonalCategoryState(
        status: PersonalCategoryStatus.subscribedCategoryListLoading);
  }

  factory PersonalCategoryState.subscribedCategoryListLoaded({
    required List<Category> subscribedCategoryList,
  }) {
    return PersonalCategoryState(
      status: PersonalCategoryStatus.subscribedCategoryListLoaded,
      subscribedCategoryList: subscribedCategoryList,
    );
  }

  factory PersonalCategoryState.subscribedCategoryListLoadingError(
      {required dynamic errorMessages}) {
    return PersonalCategoryState(
      status: PersonalCategoryStatus.subscribedCategoryListLoadingError,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'PersonalCategoryState { status: $status }';
  }
}
