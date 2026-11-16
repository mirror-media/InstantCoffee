import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/test.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:readr_app/controllers/top_iframe_controller.dart';
import 'package:readr_app/helpers/top_iframe_helper.dart';
import 'package:readr_app/widgets/top_iframe_widget.dart';

const electionIframeUrl =
    'https://dev.mnews.tw/projects/election2026-homepage/index.html';

class FakeIframeRemoteConfig extends FirebaseRemoteConfigPlatform {
  bool isVisible = true;
  bool showControls = true;
  final updates = StreamController<RemoteConfigUpdate>.broadcast();

  @override
  FirebaseRemoteConfigPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    required Map<dynamic, dynamic> remoteConfigValues,
  }) =>
      this;

  @override
  bool getBool(String key) => key == 'homepageEmbedEnabled' && isVisible;

  @override
  String getString(String key) => switch (key) {
        'homepageEmbedUrl' => electionIframeUrl,
        'homepageEmbedTitle' => showControls ? '選舉專題' : '',
        'homepageEmbedShowMoreUrl' => showControls ? electionIframeUrl : '',
        'topIframeUrl' => 'https://example.com/legacy',
        'iframeTitle' => '舊版標題',
        'iframeShowMoreUrl' => 'https://example.com/legacy-more',
        _ => '',
      };

  @override
  Future<void> setConfigSettings(RemoteConfigSettings settings) async {}

  @override
  Future<void> fetch() async {}

  @override
  Future<bool> activate() async => true;

  @override
  Stream<RemoteConfigUpdate> get onConfigUpdated => updates.stream;
}

class FakeWebViewPlatform extends InAppWebViewPlatform {
  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) =>
      FakeWebViewWidget(params);
}

class FakeWebViewWidget extends PlatformInAppWebViewWidget {
  FakeWebViewWidget(super.params) : super.implementation();
  bool disposed = false;

  @override
  Widget build(BuildContext context) => const SizedBox.expand();

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      InAppWebViewController.fromPlatform(platform: controller) as T;

  @override
  void dispose() => disposed = true;
}

class FakeWebViewController extends PlatformInAppWebViewController {
  FakeWebViewController()
      : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(id: 0),
        );

  bool disposed = false;
  int reloadCount = 0;
  final handlers = <String, JavaScriptHandlerCallback>{};
  final sources = <String>[];

  String get observationToken =>
      RegExp(r'\}\)\("([^"]+)"\);').firstMatch(sources.first)!.group(1)!;

  @override
  Future<void> reload() async => reloadCount++;

  @override
  void dispose({bool isKeepAlive = false}) => disposed = true;

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) =>
      handlers[handlerName] = callback;

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) =>
      handlers.remove(handlerName);

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    sources.add(source);
    return {'width': 320, 'height': 330};
  }

  void reportSize(double height) {
    handlers[TopIframeHelper.contentSizeHandlerName]!([
      {'token': observationToken, 'width': 320, 'height': height},
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final originalPlatform = InAppWebViewPlatform.instance;
  final originalRemoteConfig = FirebaseRemoteConfigPlatform.instance;
  final remoteConfig = FakeIframeRemoteConfig();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    FirebaseRemoteConfigPlatform.instance = remoteConfig;
  });

  tearDownAll(() async {
    await remoteConfig.updates.close();
    FirebaseRemoteConfigPlatform.instance = originalRemoteConfig;
  });

  setUp(() {
    Get.testMode = true;
    InAppWebViewPlatform.instance = FakeWebViewPlatform();
    remoteConfig.isVisible = true;
    remoteConfig.showControls = true;
  });

  tearDown(() {
    Get.reset();
    if (originalPlatform != null) {
      InAppWebViewPlatform.instance = originalPlatform;
    }
  });

  Future<void> mount(WidgetTester tester, {Widget? child}) => tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: child ?? const TopIframeWidget(controllerTag: 'test-iframe'),
          ),
        ),
      );

  Future<FakeWebViewController> load(WidgetTester tester) async {
    final platform = tester
        .widget<InAppWebView>(find.byType(InAppWebView))
        .platform as FakeWebViewWidget;
    final controller = FakeWebViewController();
    final appController = platform.controllerFromPlatform(controller);
    platform.params.onWebViewCreated!(appController);
    platform.params.onLoadStop!(appController, WebUri(electionIframeUrl));
    await tester.pump();
    return controller;
  }

  for (final screenWidth in <double>[320, 360, 1024]) {
    testWidgets('centers natural content within a $screenWidth screen', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(screenWidth, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await mount(tester);

      final webViewFinder = find.byType(InAppWebView);
      final webView = tester.widget<InAppWebView>(webViewFinder);
      expect(tester.getSize(webViewFinder), Size(screenWidth, 200));
      expect(
        webView.platform.params.initialUrlRequest?.url.toString(),
        electionIframeUrl,
      );
      expect(find.text('選舉專題'), findsOneWidget);
      expect(find.text('查看完整內容'), findsOneWidget);

      await load(tester);
      expect(tester.getSize(webViewFinder), const Size(320, 330));
      expect(tester.getCenter(webViewFinder).dx, screenWidth / 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('dynamic content grows and shrinks without a 500px cap', (
    tester,
  ) async {
    remoteConfig.showControls = false;
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(tester);
    final controller = await load(tester);
    final webViewFinder = find.byType(InAppWebView);
    controller.reportSize(900);
    await tester.pump();
    expect(tester.getSize(webViewFinder), const Size(320, 900));
    controller.reportSize(280);
    await tester.pump();
    expect(tester.getSize(webViewFinder), const Size(320, 280));
    final platform = tester.widget<InAppWebView>(webViewFinder).platform
        as FakeWebViewWidget;

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(minutes: 2));
    expect(controller.handlers, isEmpty);
    expect(
      controller.disposed,
      isFalse,
      reason: 'the widget owns native disposal',
    );
    expect(platform.disposed, isTrue);
    expect(controller.reloadCount, 0);
    expect(remoteConfig.updates.hasListener, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hide removes the iframe and its own 16px spacing', (
    tester,
  ) async {
    remoteConfig.showControls = false;
    await mount(
      tester,
      child: const Column(
        children: [
          TopIframeWidget(controllerTag: 'test-iframe'),
          SizedBox(key: ValueKey('next-component'), height: 10),
        ],
      ),
    );
    await load(tester);
    final webViewBottom = tester.getBottomLeft(find.byType(InAppWebView)).dy;
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('next-component'))).dy -
          webViewBottom,
      16,
    );
    expect(find.text('舊版標題'), findsNothing);
    expect(find.text('查看完整內容'), findsNothing);

    remoteConfig.isVisible = false;
    Get.find<TopIframeController>(tag: 'test-iframe').checkVisibility();
    await tester.pump();
    expect(find.byType(InAppWebView), findsNothing);
    expect(tester.getSize(find.byType(TopIframeWidget)).height, 0);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('next-component'))).dy,
      0,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'waitForHeightDetection still mounts the webview for measurement',
    (tester) async {
      await mount(
        tester,
        child: const TopIframeWidget(
          controllerTag: 'test-iframe',
          waitForHeightDetection: true,
        ),
      );
      expect(find.byType(InAppWebView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await load(tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.getSize(find.byType(InAppWebView)).height, 330);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('fixed-height callers keep their requested height', (
    tester,
  ) async {
    await mount(
      tester,
      child: const TopIframeWidget(
        controllerTag: 'test-iframe',
        autoHeight: false,
        height: 280,
      ),
    );
    await load(tester);
    expect(tester.getSize(find.byType(InAppWebView)), const Size(320, 280));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'removing one homepage instance leaves the other controller active',
    (tester) async {
      remoteConfig.showControls = false;
      const second = TopIframeWidget(
        key: ValueKey('second'),
        controllerTag: 'second',
      );
      await mount(
        tester,
        child: const Column(
          children: [
            TopIframeWidget(key: ValueKey('first'), controllerTag: 'first'),
            second,
          ],
        ),
      );
      final firstController = Get.find<TopIframeController>(tag: 'first');
      final secondController = Get.find<TopIframeController>(tag: 'second');
      await mount(tester, child: const Column(children: [second]));
      expect(firstController.isClosed, isTrue);
      expect(Get.isRegistered<TopIframeController>(tag: 'first'), isFalse);
      expect(
        Get.find<TopIframeController>(tag: 'second'),
        same(secondController),
      );
      expect(secondController.isClosed, isFalse);
      expect(find.byType(InAppWebView), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('a subresource error leaves the loaded embed visible', (
    tester,
  ) async {
    await mount(tester);
    final webController = await load(tester);
    final platform = tester
        .widget<InAppWebView>(find.byType(InAppWebView))
        .platform as FakeWebViewWidget;
    final wrapper = platform.controllerFromPlatform(webController);
    final error = WebResourceError(
      type: WebResourceErrorType.UNKNOWN,
      description: 'failed',
    );
    platform.params.onReceivedError!(
      wrapper,
      WebResourceRequest(
        url: WebUri('https://example.com/image.png'),
        isForMainFrame: false,
      ),
      error,
    );
    await tester.pump();
    expect(find.text('載入失敗'), findsNothing);
    expect(find.byType(InAppWebView), findsOneWidget);

    platform.params.onReceivedError!(
      wrapper,
      WebResourceRequest(url: WebUri(electionIframeUrl), isForMainFrame: true),
      error,
    );
    await tester.pump();
    expect(find.text('載入失敗'), findsOneWidget);
    expect(find.byType(InAppWebView), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
