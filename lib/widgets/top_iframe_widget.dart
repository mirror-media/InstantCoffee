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
  final bool waitForHeightDetection;
  const TopIframeWidget({
    Key? key,
    this.height = 300,
    this.refreshInterval = const Duration(minutes: 1),
    this.autoHeight = true,
    this.waitForHeightDetection = false,
  }) : super(key: key);

  @override
  State<TopIframeWidget> createState() => _TopIframeWidgetState();
}

class _TopIframeWidgetState extends State<TopIframeWidget>
    with TickerProviderStateMixin {
  late TopIframeController controller;
  late String controllerTag;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    controllerTag = 'top_iframe_${DateTime.now().millisecondsSinceEpoch}';

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    if (Get.isRegistered<TopIframeController>()) {
      Get.delete<TopIframeController>(force: true);
    }

    controller = Get.put(TopIframeController(), tag: controllerTag);
    controller.initialize(
      refreshInterval: widget.refreshInterval,
      autoHeight: widget.autoHeight,
      initialHeight: widget.height,
      waitForHeightDetection: widget.waitForHeightDetection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) {
        return const SizedBox.shrink();
      }

      if (widget.waitForHeightDetection &&
          !controller.hasDetectedHeight.value &&
          controller.isLoading.value) {
        _shimmerController.repeat(reverse: true);
        return Column(
          children: [
            if (controller.title.value != null) ...[
              _buildTitleBar(),
              const SizedBox(height: 16.0),
            ],
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: _buildSkeletonContent(),
                  ),
                  const SizedBox(height: 16.0),
                  if (controller.showMoreUrl.value != null)
                    _buildOpenExternalButton(),
                ],
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          if (controller.title.value != null) ...[
            _buildTitleBar(),
            const SizedBox(height: 16.0),
          ],
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Column(
              children: [
                _buildIframeContainer(),
                const SizedBox(height: 16.0),
                if (controller.showMoreUrl.value != null)
                  _buildOpenExternalButton(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTitleBar() {
    return Container(
      width: double.infinity,
      height: 48,
      color: appColor,
      child: Center(
        child: Text(
          controller.title.value!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildIframeContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: controller.currentHeight.value,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
        key: ValueKey(controller.webViewKey.value!),
        initialUrlRequest:
            URLRequest(url: WebUri(controller.currentUrl.value!)),
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
        onLoadStop: (controller, url) {
          this.controller.onLoadStop();
          _shimmerController.stop();
        },
        onContentSizeChanged: (controller, oldContentSize, newContentSize) {
          this.controller.onContentSizeChanged(newContentSize.height);
        },
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(_shimmerAnimation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: double.infinity * 0.7,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(_shimmerAnimation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    _shimmerController.repeat(reverse: true);

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: controller.currentHeight.value,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(_shimmerAnimation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: double.infinity,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(_shimmerAnimation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: double.infinity * 0.7,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(_shimmerAnimation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
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
              controller.errorMessage.value != null
                  ? controller.errorMessage.value!
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
    return Center(
      child: TextButton(
        onPressed: () async {
          final url = controller.showMoreUrl.value!;
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          '查看完整內容',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
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
