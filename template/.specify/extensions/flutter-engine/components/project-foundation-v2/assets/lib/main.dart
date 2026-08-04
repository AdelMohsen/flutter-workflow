import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';
import 'app/app_bootstrap.dart';
import 'app/app_config.dart';
import 'app/app_router.dart';
import 'core/network/api_client.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  if (kIsWeb) usePathUrlStrategy();

  const config = AppConfig.production();
  await AppBootstrap.initialize(config);

  final storage = AppStorage(namespace: config.storageNamespace);
  final apiClient = ApiClient(config: config, headers: storage.authHeaders);
  final router = AppRouter.create(apiClient: apiClient);

  runApp(FlutterEngineApp(router: router, storage: storage));
}
