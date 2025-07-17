import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:readr_app/controllers/top_iframe_controller.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/top_iframe_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class TopIframeWidget extends StatefulWidget {
  final double height;
  final Duration refreshInterval;
  final bool autoHeight;

  const TopIframeWidget({
    Key? key,
    this.height = 300,
    this.refreshInterval = const Duration(minutes: 1),
    this.autoHeight = true,
  }) : super(key: key);

  @override
  State<TopIframeWidget> createState() => _TopIframeWidgetState();
}

class _TopIframeWidgetState extends State<TopIframeWidget> {
  late TopIframeController controller;
  late String controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTag = 'top_iframe_${DateTime.now().millisecondsSinceEpoch}';

    if (Get.isRegistered<TopIframeController>()) {
      Get.delete<TopIframeController>(force: true);
    }

    controller = Get.put(TopIframeController(), tag: controllerTag);
    controller.initialize(
      refreshInterval: widget.refreshInterval,
      autoHeight: widget.autoHeight,
      initialHeight: widget.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Column(
          children: [
            _buildIframeContainer(),
            const SizedBox(height: 16.0),
            _buildOpenExternalButton(),
          ],
        ),
      );
    });
  }

  Widget _buildIframeContainer() {
    return Container(
      height: controller.currentHeight.value,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          _buildWebView(),
          if (controller.isLoading.value) _buildLoadingIndicator(),
          if (controller.hasError.value) _buildErrorIndicator(),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InAppWebView(
        key: ValueKey(controller.webViewKey.value),
        initialUrlRequest: URLRequest(url: WebUri(controller.currentUrl.value)),
        initialSettings: TopIframeHelper.createWebViewSettings(),
        onWebViewCreated: controller.onWebViewCreated,
        onLoadStart: (controller, url) => this.controller.onLoadStart(),
        onProgressChanged: (controller, progress) {},
        onReceivedError: (controller, request, error) {
          this.controller.onLoadError(error.description);
        },
        onReceivedHttpError: (controller, request, errorResponse) {
          this.controller.onLoadHttpError(errorResponse.statusCode ?? 0);
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) => this.controller.onLoadStop(),
        onContentSizeChanged: (controller, oldContentSize, newContentSize) {
          this.controller.onContentSizeChanged(newContentSize.height);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
      height: controller.currentHeight.value,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      width: double.infinity,
      height: controller.currentHeight.value,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : '載入失敗',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.retryLoading,
              child: const Text('重試'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenExternalButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          final url = controller.currentUrl.value;
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          } else {
            throw Exception('無法開啟連結: $url');
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: appColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.open_in_new, size: 18),
            SizedBox(width: 8),
            Text(
              '查看完整內容',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      Get.delete<TopIframeController>(tag: controllerTag, force: true);
    } catch (e) {
      try {
        Get.delete<TopIframeController>(force: true);
      } catch (e) {}
    }
    super.dispose();
  }
}
