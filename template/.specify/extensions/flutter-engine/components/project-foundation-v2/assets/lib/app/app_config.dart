enum FlavorEnum { development, staging, production }

final class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.baseUrl,
    required this.storageNamespace,
    this.traceNetworkBodies = false,
  });

  const AppConfig.production()
    : this(
        flavor: FlavorEnum.production,
        baseUrl: '',
        storageNamespace: 'flutter_app',
      );

  final FlavorEnum flavor;
  final String baseUrl;
  final String storageNamespace;
  final bool traceNetworkBodies;

  bool get hasConfiguredApi {
    final uri = Uri.tryParse(baseUrl);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
