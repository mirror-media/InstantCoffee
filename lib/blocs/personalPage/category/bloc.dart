import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/services/categoryService.dart';

class PersonalCategoryBloc extends Bloc<PersonalCategoryEvents, PersonalCategoryState> {
  final CategoryRepos categoryRepos;
  PersonalCategoryBloc({
    required this.categoryRepos,
  }) : super(PersonalCategoryState.init()){
    on<FetchSubscribedCategoryList>(_fetchSubscribedCategoryList);
    on<SetCategoryListInStorage>(_setCategoryListInStorage);
  }

  LocalStorage _storage = LocalStorage('setting');

  void _fetchSubscribedCategoryList(
    FetchSubscribedCategoryList event,
    Emitter<PersonalCategoryState> emit,
  ) async{
    print(event.toString());
    try{
      emit(PersonalCategoryState.subscribedCategoryListLoading());

      List<Category>? localCategoryList;
      List<Category> onlineCategoryList = await categoryRepos.fetchCategoryList();
      if (await _storage.ready) {
        if(_storage.getItem("categoryList") != null) {
          localCategoryList =
              Category.categoryListFromJson(_storage.getItem("categoryList"));
        }
      }

      List<Category> theNewestCategoryList = Category.getTheNewestCategoryList(
          localCategoryList: localCategoryList,
          onlineCategoryList: onlineCategoryList);

      emit(PersonalCategoryState.subscribedCategoryListLoaded(
        subscribedCategoryList: theNewestCategoryList,
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
    print(event.toString());
    _storage.setItem("categoryList", Category.categoryListToJson(event.categoryList));
    emit(PersonalCategoryState.subscribedCategoryListLoaded(
      subscribedCategoryList: event.categoryList,
    ));
  }
}
