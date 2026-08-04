import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/debug/app_logger.dart';
import 'app_config.dart';

abstract final class AppBootstrap {
  static Future<void> initialize(AppConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = kDebugMode;

    AppLogger.info('BOOT', 'Starting ${config.flavor.name} build');
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    AppLogger.info('BOOT', 'Bootstrap complete');
  }
}
