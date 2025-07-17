import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/top_iframe_helper.dart';

class TopIframeController extends GetxController {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble currentHeight = 300.0.obs;
  final RxString currentUrl = ''.obs;
  final RxString webViewKey = ''.obs;
  final RxBool isVisible = false.obs;

  InAppWebViewController? webViewController;
  Timer? refreshTimer;
  Timer? loadingTimeoutTimer;

  late Duration refreshInterval;
  late bool autoHeight;
  late double initialHeight;

  void initialize({
    Duration refreshInterval = const Duration(minutes: 1),
    bool autoHeight = true,
    double initialHeight = 300,
  }) {
    this.refreshInterval = refreshInterval;
    this.autoHeight = autoHeight;
    this.initialHeight = initialHeight;

    currentHeight.value = initialHeight;
    webViewKey.value = TopIframeHelper.generateWebViewKey('');

    checkVisibility();
    startAutoRefresh();
  }

  void checkVisibility() {
    bool isShow = _remoteConfigHelper.isTopIframeShow;
    String url = _remoteConfigHelper.topIframeUrl;

    isVisible.value = isShow && url.isNotEmpty;

    if (isVisible.value) {
      if (currentUrl.value != url) {
        currentUrl.value = url;
        resetWebViewState();
      }
    }
  }

  void resetWebViewState() {
    TopIframeHelper.safeDisposeWebView(webViewController);
    webViewController = null;

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    webViewKey.value = TopIframeHelper.generateWebViewKey(currentUrl.value);
  }

  void startAutoRefresh() {
    refreshTimer?.cancel();
    refreshTimer = Timer.periodic(refreshInterval, (timer) {
      if (webViewController != null) {
        refreshIframe();
      }
    });
  }

  void refreshIframe() async {
    if (webViewController != null) {
      await webViewController!.reload();
    }
  }

  void retryLoading() {
    resetWebViewState();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onLoadStart() {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    loadingTimeoutTimer?.cancel();
    loadingTimeoutTimer = Timer(const Duration(seconds: 30), () {
      if (isLoading.value) {
        onLoadTimeout();
      }
    });
  }

  void onLoadTimeout() {
    isLoading.value = false;
    hasError.value = true;
    errorMessage.value = '載入超時，請重試';
  }

  void onLoadStop() {
    loadingTimeoutTimer?.cancel();
    isLoading.value = false;
    hasError.value = false;

    if (autoHeight && webViewController != null) {
      performHeightDetection();
    }
  }

  void onLoadError(String message) {
    loadingTimeoutTimer?.cancel();
    isLoading.value = false;
    hasError.value = true;
    errorMessage.value = '載入錯誤: $message';
  }

  void onLoadHttpError(int statusCode) {
    loadingTimeoutTimer?.cancel();
    isLoading.value = false;
    hasError.value = true;
    errorMessage.value = 'HTTP 錯誤: $statusCode';
  }

  void performHeightDetection() async {
    if (webViewController == null) return;

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final detectedHeight =
          await TopIframeHelper.detectHeight(webViewController!);

      if (detectedHeight != null) {
        updateHeight(detectedHeight);
      }

      await Future.delayed(const Duration(milliseconds: 1500));
      final finalHeight =
          await TopIframeHelper.detectHeight(webViewController!);

      if (finalHeight != null) {
        updateHeight(finalHeight);
      }
    } catch (e) {}
  }

  void updateHeight(double newHeight) {
    if (TopIframeHelper.shouldUpdateHeight(currentHeight.value, newHeight)) {
      currentHeight.value = newHeight;
    }
  }

  void onContentSizeChanged(double newHeight) {
    if (autoHeight && newHeight > 0) {
      final calculatedHeight =
          TopIframeHelper.calculateContentHeight(newHeight);
      updateHeight(calculatedHeight);
    }
  }

  @override
  void onClose() {
    refreshTimer?.cancel();
    refreshTimer = null;
    loadingTimeoutTimer?.cancel();
    loadingTimeoutTimer = null;

    if (webViewController != null) {
      TopIframeHelper.safeDisposeWebView(webViewController);
      webViewController = null;
    }
    super.onClose();
  }
}
