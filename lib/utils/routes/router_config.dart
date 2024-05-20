import 'dart:async';

import 'package:flutter/material.dart';
import './page_builders.dart';
import 'package:go_router/go_router.dart';

const routeHome = 'home';

final router = GoRouter(
  onException: (_, GoRouterState state, GoRouter router) {
    router.goNamed(routeHome, extra: state.uri.toString());
  },
  errorBuilder: homeBuilder,
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: routeHome,
      builder: homeBuilder,
    ),
  ],
);