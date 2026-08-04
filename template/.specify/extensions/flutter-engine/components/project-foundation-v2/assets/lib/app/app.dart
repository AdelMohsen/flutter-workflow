import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../core/storage/app_storage.dart';
import '../core/theme/app_theme.dart';
import '../core/ui/adaptive/adaptive_widgets.dart';
import '../l10n/app_localizations.dart';
import 'app_state.dart';

final class FlutterEngineApp extends StatelessWidget {
  const FlutterEngineApp({
    required this.router,
    required this.storage,
    super.key,
  });

  final GoRouter router;
  final AppStorage storage;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => AppCubit(storage)..load(),
    child: BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => ToastificationWrapper(
        child: GlobalLoaderOverlay(
          overlayWidgetBuilder: (_) => const Center(child: AdaptiveLoader()),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          ),
        ),
      ),
    ),
  );
}
