import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import './utils/routes/router_config.dart';
import './widgets/backwards_view.dart';
//import 'package:rate_my_app/rate_my_app.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationProvider: router.routeInformationProvider,
    routeInformationParser: router.routeInformationParser,
    routerDelegate: router.routerDelegate,
  );
}

class MyAppPage extends StatefulWidget {
  final String url;

  const MyAppPage({super.key, required this.url});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings =
  InAppWebViewSettings(isInspectable: kDebugMode, transparentBackground: true);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.blue,
  );
  bool pullToRefreshEnabled = true;
  /*RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3, // Show rate popup on first day of install.
    minLaunches: 5, // Show rate popup after 5 launches of app after minDays is passed.
  );*/

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      settings: pullToRefreshSettings,
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest:
              URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackwardsView(onBackPressed: (BuildContext context) async {
          if(webViewController == null) return false;
          if(await webViewController!.canGoBack()) {
            if(!mounted) return false;
            webViewController!.goBack();
            return true;
          }
          return false;
        },
        child: SafeArea(child: /*widget.url.isNotEmpty ? Text(widget.url) : */InAppWebView(
          initialUrlRequest:
          URLRequest(url: WebUri(widget.url)),
          initialSettings: settings,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            FlutterNativeSplash.remove();
          },
          onLoadStop: (controller, url) {
            pullToRefreshController?.endRefreshing();
          },
          onReceivedError: (controller, request, error) {
            pullToRefreshController?.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
          },
        ))
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
