import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/iAPSubscriptionHelper.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

class SubscriptionSelectBloc extends Bloc<SubscriptionSelectEvents, SubscriptionSelectState> {
  final SubscriptionSelectRepos subscriptionSelectRepos;
  StreamSubscription<PurchaseDetails>
      _buyingPurchaseSubscription;
  SubscriptionSelectBloc({this.subscriptionSelectRepos}) : super(SubscriptionSelectState.init()) {
    on<FetchSubscriptionProducts>(_fetchSubscriptionProducts);
    on<BuySubscriptionProduct>(_buySubscriptionProduct);
    on<BuyingPurchaseStatusChanged>(_buyingPurchaseStatusChanged);

    IAPSubscriptionHelper iapSubscriptionHelper = IAPSubscriptionHelper();
    _buyingPurchaseSubscription = iapSubscriptionHelper.buyingPurchaseController.stream.listen(
      (purchaseDetails) => add(BuyingPurchaseStatusChanged(purchaseDetails)),
    );
  }

  @override
  Future<void> close() {
    _buyingPurchaseSubscription.cancel();
    return super.close();
  }

  bool _isMonthlyOrYearlySubscriber(SubscritionType subscritionType) {
    return subscritionType == SubscritionType.subscribe_monthly || 
    subscritionType == SubscritionType.subscribe_yearly;
  }

  void _fetchSubscriptionProducts(
    FetchSubscriptionProducts event,
    Emitter<SubscriptionSelectState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SubscriptionSelectState.loading());
      List<ProductDetails>  productDetailList = await subscriptionSelectRepos.fetchProductDetailList();
      PurchaseDetails previousPurchaseDetails;
      if(_isMonthlyOrYearlySubscriber(event.subscritionType) && Platform.isAndroid) {
        previousPurchaseDetails = await subscriptionSelectRepos.fetchAndroidSubscriptionDetail();
      }
      emit(SubscriptionSelectState.loaded(
        productDetailList: productDetailList,
        previousPurchaseDetails: previousPurchaseDetails
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

  void _buySubscriptionProduct(
    BuySubscriptionProduct event,
    Emitter<SubscriptionSelectState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SubscriptionSelectState.buying(
        productDetailList: state.productDetailList
      ));
      bool buySuccess = await subscriptionSelectRepos.buySubscriptionProduct(event.purchaseParam);
      if(buySuccess) {
      } else {
        Fluttertoast.showToast(
          msg: '購買失敗，請再試一次',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );

        emit(SubscriptionSelectState.loaded(
          productDetailList: state.productDetailList,
          previousPurchaseDetails: state.previousPurchaseDetails
        ));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '購買失敗，請再試一次',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );

      emit(SubscriptionSelectState.loaded(
        productDetailList: state.productDetailList,
        previousPurchaseDetails: state.previousPurchaseDetails
      ));
    }
  }

  void _buyingPurchaseStatusChanged(
    BuyingPurchaseStatusChanged event,
    Emitter<SubscriptionSelectState> emit,
  ) {
    PurchaseDetails purchaseDetails = event.purchaseDetails;
    if(purchaseDetails.status == PurchaseStatus.canceled) {
      emit(SubscriptionSelectState.loaded(
        productDetailList: state.productDetailList,
        previousPurchaseDetails: state.previousPurchaseDetails
      ));
    } else if(purchaseDetails.status == PurchaseStatus.purchased) {
      Fluttertoast.showToast(
        msg: '變更方案成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
      emit(SubscriptionSelectState.buyingSuccess());
    } else if(purchaseDetails.status == PurchaseStatus.error) {
      print("error code: ${purchaseDetails.error.code}");
      print("error message: ${purchaseDetails.error.message}");
      Fluttertoast.showToast(
        msg: '購買失敗，請再試一次',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );

      emit(SubscriptionSelectState.loaded(
        productDetailList: state.productDetailList,
        previousPurchaseDetails: state.previousPurchaseDetails
      ));
    }
  }
}
