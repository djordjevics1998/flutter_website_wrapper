import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:go_router/go_router.dart';

const websiteUrl = 'bilten.rs/', 
    httpWebsiteUrl = 'http://$websiteUrl',
    httpsWebsiteUrl = 'https://$websiteUrl';

Widget homeBuilder(BuildContext context, GoRouterState state) => MyAppPage(
  url: state.extra as String? ?? httpsWebsiteUrl,
);