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
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/subscriptionDetail.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

class SubscriptionSelectBloc extends Bloc<SubscriptionSelectEvents, SubscriptionSelectState> {
  IAPSubscriptionHelper _iapSubscriptionHelper = IAPSubscriptionHelper();
  final SubscriptionSelectRepos subscriptionSelectRepos;
  final String storySlug;

  StreamSubscription<PurchaseDetails> _buyingPurchaseSubscription;

  SubscriptionSelectBloc({
    this.subscriptionSelectRepos,
    this.storySlug
  }) : super(SubscriptionSelectState.init()) {
    _iapSubscriptionHelper.verifyPurchaseInBloc = true;

    on<FetchSubscriptionProducts>(_fetchSubscriptionProducts);
    on<BuySubscriptionProduct>(_buySubscriptionProduct);
    on<BuyingPurchaseStatusChanged>(_buyingPurchaseStatusChanged);

    _buyingPurchaseSubscription = _iapSubscriptionHelper.buyingPurchaseController.stream.listen(
      (purchaseDetails) => add(BuyingPurchaseStatusChanged(purchaseDetails)),
    );
  }

  @override
  Future<void> close() {
    _iapSubscriptionHelper.verifyPurchaseInBloc = false;
    _buyingPurchaseSubscription.cancel();
    return super.close();
  }

  void _fetchSubscriptionProducts(
    FetchSubscriptionProducts event,
    Emitter<SubscriptionSelectState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SubscriptionSelectState.loading());

      SubscriptionDetail subscriptionDetail = await subscriptionSelectRepos.fetchSubscriptionDetail();
      List<ProductDetails> productDetailList = await subscriptionSelectRepos.fetchProductDetailList();

      emit(SubscriptionSelectState.loaded(
        subscriptionDetail: subscriptionDetail,
        productDetailList: productDetailList,
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
        subscriptionDetail: state.subscriptionDetail,
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
          subscriptionDetail: state.subscriptionDetail,
          productDetailList: state.productDetailList,
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
        subscriptionDetail: state.subscriptionDetail,
        productDetailList: state.productDetailList,
      ));
    }
  }

  void _buyingPurchaseStatusChanged(
    BuyingPurchaseStatusChanged event,
    Emitter<SubscriptionSelectState> emit,
  ) async{
    PurchaseDetails purchaseDetails = event.purchaseDetails;
    if(purchaseDetails.status == PurchaseStatus.canceled) {
      if(Platform.isIOS) {
        await _iapSubscriptionHelper.completePurchase(purchaseDetails);
      }
      emit(SubscriptionSelectState.loaded(
        subscriptionDetail: state.subscriptionDetail,
        productDetailList: state.productDetailList,
      ));
    } else if(purchaseDetails.status == PurchaseStatus.purchased) {
      bool isSuccess = await _iapSubscriptionHelper.verifyEntirePurchase(purchaseDetails);
      if(isSuccess) {
        Fluttertoast.showToast(
          msg: '變更方案成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );

        RouteGenerator.navigatorKey.currentState.popUntil((route) => route.isFirst);
        if(this.storySlug != null) {
          RouteGenerator.navigateToStory(storySlug);
        } else {
          RouteGenerator.navigateToLogin();
        }
      } else {
        Fluttertoast.showToast(
          msg: '變更方案成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        emit(SubscriptionSelectState.verifyPurchaseFail());
      }
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
        subscriptionDetail: state.subscriptionDetail,
        productDetailList: state.productDetailList,
      ));
    }
  }
}
