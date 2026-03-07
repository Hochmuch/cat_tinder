import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import '../../domain/services/analytics_service.dart';

class AppMetricaAnalyticsService implements AnalyticsService {
  AppMetricaAnalyticsService._();

  static Future<AppMetricaAnalyticsService> create(String apiKey) async {
    await AppMetrica.activate(AppMetricaConfig(apiKey));
    return AppMetricaAnalyticsService._();
  }

  @override
  Future<void> logEvent(String name) {
    return AppMetrica.reportEvent(name);
  }
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> logEvent(String name) async {}
}
