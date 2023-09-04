import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/local_storage_provider.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/services/category_service.dart';
import 'package:readr_app/widgets/logger.dart';

class PersonalCategoryBloc
    extends Bloc<PersonalCategoryEvents, PersonalCategoryState> with Logger {
  final CategoryRepos categoryRepos;

  PersonalCategoryBloc({
    required this.categoryRepos,
  }) : super(PersonalCategoryState.init()) {
    on<FetchSubscribedCategoryList>(_fetchSubscribedCategoryList);
    on<SetCategoryListInStorage>(_setCategoryListInStorage);
  }

  final ArticlesApiProvider articlesApiProvider = Get.find();
  final LocalStorageProvider localStorageProvider = Get.find();
  final LocalStorage _storage = LocalStorage('setting');

  void _fetchSubscribedCategoryList(
    FetchSubscribedCategoryList event,
    Emitter<PersonalCategoryState> emit,
  ) async {
    debugLog(event.toString());

    try {
      emit(PersonalCategoryState.subscribedCategoryListLoading());
      List<Category>? localCategoryList =
          await localStorageProvider.loadCategoryList();

      if (await _storage.ready &&  localCategoryList ==null) {
        if (_storage.getItem("categoryList") != null) {
          localCategoryList =
              Category.categoryListFromJson(_storage.getItem("categoryList"));
          _storage.deleteItem('categoryList');
        }
      }
      List<Category> onlineCategoryList =
          await articlesApiProvider.getCategoriesList();

      if (localCategoryList == null || localCategoryList.isEmpty) {
        localStorageProvider.saveCategoryList(onlineCategoryList);
        localCategoryList = onlineCategoryList;
      }

      emit(PersonalCategoryState.subscribedCategoryListLoaded(
        subscribedCategoryList: localCategoryList,
      ));
    } catch (e) {
      emit(PersonalCategoryState.subscribedCategoryListLoadingError(
        errorMessages: e,
      ));
    }
  }

  _setCategoryListInStorage(
    SetCategoryListInStorage event,
    Emitter<PersonalCategoryState> emit,
  ) {
    debugLog(event.toString());
    localStorageProvider.saveCategoryList(event.categoryList);
    emit(PersonalCategoryState.subscribedCategoryListLoaded(
      subscribedCategoryList: event.categoryList,
    ));
  }
}
