import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

class SubscriptionSelectBloc extends Bloc<SubscriptionSelectEvents, SubscriptionSelectState> {
  final SubscriptionSelectRepos subscriptionSelectRepos;

  SubscriptionSelectBloc({this.subscriptionSelectRepos}) : super(SubscriptionSelectState.init()) {
    on<FetchSubscriptionProducts>(_fetchSubscriptionProducts);
  }

  void _fetchSubscriptionProducts(
    FetchSubscriptionProducts event,
    Emitter<SubscriptionSelectState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SubscriptionSelectState.loading());
      List<ProductDetails> productDetailList = await subscriptionSelectRepos.fetchProductDetailList();
      emit(SubscriptionSelectState.loaded(
        productDetailList: productDetailList
      ));
    } on SocketException {
      emit(SubscriptionSelectState.error(
        errorMessages: NoInternetException('No Internet'),
      ));
    } on HttpException {
      emit(SubscriptionSelectState.error(
        errorMessages: NoServiceFoundException('No Service Found'),
      ));
    } on FormatException {
      emit(SubscriptionSelectState.error(
        errorMessages: InvalidFormatException('Invalid Response format'),
      ));
    } catch (e) {
      emit(SubscriptionSelectState.error(
        errorMessages: UnknownException(e.toString()),
      ));
    }
  }
}
