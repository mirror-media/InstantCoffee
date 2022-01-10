import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:readr_app/models/subscriptionDetail.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/verifyPurchaseFailWidget.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/hintToOtherPlatform.dart';

class SubscriptionSelectWidget extends StatefulWidget {
  SubscriptionSelectWidget();
  @override
  _SubscriptionSelectWidgetState createState() => _SubscriptionSelectWidgetState();
}

class _SubscriptionSelectWidgetState extends State<SubscriptionSelectWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionProducts();
  }

  bool _isSubscribed(SubscriptionType subscriptionType) {
    return subscriptionType == SubscriptionType.subscribe_monthly || 
        subscriptionType == SubscriptionType.subscribe_yearly;
  }

  bool _isTheSamePlatfrom(PaymentType paymentType) {
    if(paymentType == null) {
      return true;
    }

    if(paymentType == PaymentType.google_play && Platform.isAndroid) {
      return true;
    } else if (paymentType == PaymentType.app_store && Platform.isIOS) {
      return true;
    }

    return false;
  }

  _fetchSubscriptionProducts() {
    context.read<SubscriptionSelectBloc>().add(
      FetchSubscriptionProducts()
    );
  }

  _buySubscriptionProduct(PurchaseParam purchaseParam) {
    context.read<SubscriptionSelectBloc>().add(
      BuySubscriptionProduct(purchaseParam)
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionSelectBloc, SubscriptionSelectState>(
      builder: (BuildContext context, SubscriptionSelectState state) {
        switch (state.status) {
          case SubscriptionSelectStatus.error:
            final error = state.errorMessages;
            print('SubscriptionProductsLoadedFail: ${error.message}');
            return Container();
          case SubscriptionSelectStatus.loaded:
            SubscriptionDetail subscriptionDetail = state.subscriptionDetail;
            List<ProductDetails> productDetailList = state.productDetailList;

            Widget body = HintToOtherPlatform(paymentType: subscriptionDetail.paymentType);

            if(_isTheSamePlatfrom(subscriptionDetail.paymentType)) {
              body = ListView(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _memberIntroBlock(
                      subscriptionDetail.subscriptionType,
                      productDetailList
                    ),
                  ),
                  SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _memberAttention(),
                  ),
                  SizedBox(height: 48),
                ],
              );
            }

            return Scaffold(
              appBar: _buildBar(
                context, 
                subscriptionType: subscriptionDetail.subscriptionType
              ),
              body: body
            ); 
          case SubscriptionSelectStatus.buying:
            SubscriptionDetail subscriptionDetail = state.subscriptionDetail;
            List<ProductDetails> productDetailList = state.productDetailList;

            return Scaffold(
              appBar: _buildBar(
                context, 
                subscriptionType: subscriptionDetail.subscriptionType
              ),
              body: ListView(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _memberIntroBlock(
                      subscriptionDetail.subscriptionType,
                      productDetailList, 
                      isBuying: true
                    ),
                  ),
                  SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _memberAttention(),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            );
          case SubscriptionSelectStatus.verifyPurchaseFail: 
            return Scaffold(
              appBar: _buildBar(context),
              body: VerifyPurchaseFailWidget()
            );
          default:
            // state is Init, Loading
            return Scaffold(
              appBar: _buildBar(context),
              body: _loadingWidget()
            );
        }
      }
    );
  }

  Widget _buildBar(
    BuildContext context, 
    {SubscriptionType subscriptionType}
  ) {
    String titleText = '';
    if(subscriptionType == SubscriptionType.subscribe_one_time || subscriptionType == SubscriptionType.none){
      titleText = '升級會員';
    } else if(_isSubscribed(subscriptionType)){
      titleText = '變更方案';
    }

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        titleText,
      ),
      backgroundColor: appColor,
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _memberIntroBlock(
    SubscriptionType subscriptionType,
    List<ProductDetails> productDetailList,
    {bool isBuying = false}
  ) {
    double width = MediaQuery.of(context).size.width;
    String boxTitle = 'Premium 會員';
    if(subscriptionType == SubscriptionType.subscribe_monthly){
      boxTitle = '變更為年訂閱方案';
    }
    else if(subscriptionType == SubscriptionType.subscribe_yearly){
      boxTitle = '變更為月訂閱方案';
    }

    int originalPrice = 99;
    int specialPrice = 50;

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  boxTitle,
                  style: TextStyle(
                    color: appColor,
                    fontSize: 20,
                  ),
                ),
                Image.asset(
                  'assets/image/badge.png',
                  width: 60,
                  height:80,
                ),
              ],
            ),
            _memberClause('支持鏡週刊報導精神'),
            Divider(),
            _memberClause('暢讀鏡週刊全站內容'),
            Divider(),
            _memberClause('會員專區零廣告純淨閱覽'),
            Divider(),
            _memberClause('專區好文不分頁流暢閱讀'),
            Divider(),
            _memberClause('免費閱讀數位版動態雜誌'),
            Divider(),
            _memberClause('月方案定價 \$$originalPrice 元，限時優惠 \$$specialPrice 元'),
            SizedBox(height: 24),
            isBuying
            ? Column(
                children: [
                  Text(
                    '購買中',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  SpinKitThreeBounce(color: appColor, size: 35,),
                ],
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12),
                itemCount: productDetailList.length,
                itemBuilder: (context, index) {
                  final ButtonStyle buttonStyle = TextButton.styleFrom(
                    backgroundColor: index%2==0 ? appColor : Colors.white,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                  );

                  return OutlinedButton(
                    style: buttonStyle,
                    child: Container(
                      width: width,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              productDetailList[index].title,
                              style: TextStyle(
                                fontSize: 18,
                                color: index%2==0 ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '優惠 ${productDetailList[index].price} 元',
                              style: TextStyle(
                                fontSize: 13,
                                color: index%2==0 ? Colors.white60 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () async{
                      await _auth.currentUser.reload();
                      if(_auth.currentUser.emailVerified) {
                        PurchaseParam purchaseParam = PurchaseParam(
                            productDetails: productDetailList[index],
                        );

                        _buySubscriptionProduct(purchaseParam);
                      } else {
                        RouteGenerator.navigateToEmailVerification();
                      }
                    },
                  );
                }
              ),

            if(_isSubscribed(subscriptionType))...[
              SizedBox(height: 12),
              Text(
                '變更將在本次收費週期結束時生效',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ]
          ],
        ),
      )
    );
  }

  Widget _memberClause(String title, {Color textColor = Colors.black54}) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: appColor,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ]
    );
  }

  Widget _memberAttention() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '注意事項',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        SizedBox(height: 12),
        _orderClause(1, '月方案計算天數為 30 日，年方案計算天數為 365 日。'),
        _orderClause(2, '月訂閱方案經會員授權扣款購買即為完成服務，因此月費會員無法退費，但可取消繼續訂閱。'),
        _orderClause(3, '訂閱購買的同時會開啓自動續費(扣款)，在訂閱到期時將依據原訂閱方案自動扣款，並延續訂閱。'),
        _orderClause(4, '訂閱相關問題請 email 至會員專屬客服信箱 MM-onlineservice@mirrormedia.mg， 我們會盡快為您協助處理。'),
        _orderClause(5, '更多詳細內容，請至服務條款。'),
        _orderClause(6, """本抽獎活動為機會中獎活動，依中華民國稅法規定，中獎金額超過 NT\$1,000元，中獎人須併入個人年度綜合所得稅申報；若中獎金額超過 NT\$20,010元，中獎人須自行負擔10%之機會中獎所得稅（非中華民國境內居住之個人為20%）並配合本公司辦理代扣繳相關事宜(得獎者應先繳納中獎所得稅後，本公司方將中獎獎項提供予得獎人)。
中獎人須提供姓名、身分證字號、戶籍地址及身分證正、反面影本，以供本公司依法向稅捐機關進行年度申報作業。"""),
      ],
    );
  }

  Widget _orderClause(int order, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}