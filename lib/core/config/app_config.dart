enum AppFlavor { superApp, patient, doctor, pharmacy, admin }

class AppConfig {
  final String baseUrl;
  final String appName;
  final AppFlavor flavor;

  static late AppConfig instance;

  AppConfig._({
    required this.baseUrl,
    required this.appName,
    required this.flavor,
  });

  factory AppConfig({
    required String baseUrl,
    required String appName,
    required AppFlavor flavor,
  }) {
    instance = AppConfig._(baseUrl: baseUrl, appName: appName, flavor: flavor);
    return instance;
  }
}
