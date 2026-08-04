import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/debug/app_logger.dart';
import '../core/network/api_client.dart';
import '../l10n/app_localizations.dart';
import 'component_showcase.dart';

abstract final class AppRouter {
  static GoRouter create({
    required ApiClient apiClient,
    List<RouteBase> featureRoutes = const [],
  }) => GoRouter(
    debugLogDiagnostics: kDebugMode,
    observers: [_AppRouteObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: 'showcase',
        builder: (context, state) =>
            ComponentShowcase(apiConfigured: apiClient.isConfigured),
      ),
      ...featureRoutes,
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(AppLocalizations.of(context)!.routeNotFound)),
    ),
  );
}

final class _AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.debug('ROUTER', 'Push ${route.settings.name ?? route}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.debug('ROUTER', 'Pop ${route.settings.name ?? route}');
  }
}
