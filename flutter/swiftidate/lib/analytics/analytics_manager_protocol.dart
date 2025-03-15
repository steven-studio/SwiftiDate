// analytics_manager_protocol.dart
abstract class AnalyticsManagerProtocol {
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? parameters});
}
