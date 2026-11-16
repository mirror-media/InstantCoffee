import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:readr_app/controllers/top_iframe_controller.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/top_iframe_helper.dart';
import 'package:readr_app/widgets/top_iframe_gesture_recognizer.dart';
import 'package:url_launcher/url_launcher.dart';

class TopIframeWidget extends StatefulWidget {
  const TopIframeWidget({
    super.key,
    this.height = 300,
    this.refreshInterval = const Duration(minutes: 1),
    this.autoHeight = true,
    this.waitForHeightDetection = false,
    this.controllerTag,
  });

  final double height;
  final Duration refreshInterval;
  final bool autoHeight;
  final bool waitForHeightDetection;
  final String? controllerTag;

  @override
  State<TopIframeWidget> createState() => _TopIframeWidgetState();
}

class _TopIframeWidgetState extends State<TopIframeWidget> {
  static const double _sectionSpacing = 16;
  late final String _controllerTag;
  late final TopIframeController _controller;

  @override
  void initState() {
    super.initState();
    _controllerTag = widget.controllerTag ?? 'top_iframe_${UniqueKey()}';
    _controller = Get.put(
      TopIframeController(
        refreshInterval: widget.refreshInterval,
        autoHeight: widget.autoHeight,
        initialHeight: widget.height,
      ),
      tag: _controllerTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final url = _controller.currentUrl.value;
      if (!_controller.isVisible.value || url == null) {
        return const SizedBox.shrink();
      }

      final contentWidth = _controller.currentWidth.value;
      final contentHeight = _controller.currentHeight.value;
      final instanceKey = _controller.webViewKey.value;
      final hasError = _controller.hasError.value;
      final isLoading = _controller.isLoading.value ||
          (widget.waitForHeightDetection &&
              widget.autoHeight &&
              !_controller.hasDetectedHeight.value);
      final errorMessage = _controller.errorMessage.value;
      final title = _controller.title.value;
      final showMoreUrl = _controller.showMoreUrl.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Container(
              width: double.infinity,
              height: 48,
              color: appColor,
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: _sectionSpacing),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final width = (contentWidth ?? availableWidth)
                  .clamp(0.0, availableWidth)
                  .toDouble();

              return Center(
                child: SizedBox(
                  width: width,
                  height: contentHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!hasError)
                        Opacity(
                          opacity: isLoading ? 0 : 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: InAppWebView(
                              key: ValueKey(instanceKey),
                              gestureRecognizers: {
                                Factory<TopIframeVerticalDragGestureRecognizer>(
                                  () => TopIframeVerticalDragGestureRecognizer(
                                    isDropdownOpen: () =>
                                        _controller.isDropdownOpen,
                                  )..gestureSettings =
                                        MediaQuery.gestureSettingsOf(
                                      context,
                                    ),
                                ),
                              },
                              initialUrlRequest: URLRequest(url: WebUri(url)),
                              initialSettings:
                                  TopIframeHelper.createWebViewSettings(),
                              onWebViewCreated: (webController) {
                                _controller.onWebViewCreated(
                                  webController,
                                  instanceKey: instanceKey,
                                );
                              },
                              onLoadStart: (webController, url) {
                                _controller.onLoadStart(
                                  webController: webController,
                                  instanceKey: instanceKey,
                                );
                              },
                              onLoadStop: (webController, url) async {
                                await _controller.onLoadStop(
                                  webController: webController,
                                  instanceKey: instanceKey,
                                );
                              },
                              onReceivedError: (webController, request, error) {
                                if (request.isForMainFrame == false) return;
                                _controller.onLoadError(
                                  error.description,
                                  webController: webController,
                                  instanceKey: instanceKey,
                                );
                              },
                              onReceivedHttpError:
                                  (webController, request, response) {
                                if (request.isForMainFrame == false) return;
                                _controller.onLoadError(
                                  'HTTP 錯誤: ${response.statusCode ?? 0}',
                                  webController: webController,
                                  instanceKey: instanceKey,
                                );
                              },
                              shouldOverrideUrlLoading:
                                  (webController, action) async =>
                                      NavigationActionPolicy.ALLOW,
                            ),
                          ),
                        ),
                      if (isLoading && !hasError)
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      if (hasError)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 32),
                                const SizedBox(height: 8),
                                const Text('載入失敗'),
                                if (errorMessage != null)
                                  Text(
                                    errorMessage,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                const SizedBox(height: 8),
                                OutlinedButton.icon(
                                  onPressed: _controller.manualRefresh,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('重試'),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (showMoreUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: _sectionSpacing),
              child: TextButton(
                onPressed: () => launchUrl(
                  Uri.parse(showMoreUrl),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  backgroundColor: appColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '查看完整內容',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          const SizedBox(height: _sectionSpacing),
        ],
      );
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<TopIframeController>(tag: _controllerTag)) {
      Get.delete<TopIframeController>(tag: _controllerTag, force: true);
    }
    super.dispose();
  }
}
