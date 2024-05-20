import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:go_router/go_router.dart';

const _websiteUrl = 'https://bilten.rs/';

Widget homeBuilder(BuildContext context, GoRouterState state) => MyAppPage(
  url: state.extra as String? ?? _websiteUrl,
);