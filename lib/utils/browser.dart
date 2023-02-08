import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppWebViewGroupOptions getDefaultBrowserOption() => InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
      javaScriptEnabled: true,
      preferredContentMode: UserPreferredContentMode.DESKTOP,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      javaScriptCanOpenWindowsAutomatically: true,
      cacheEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
        useHybridComposition: true, supportMultipleWindows: true),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ));