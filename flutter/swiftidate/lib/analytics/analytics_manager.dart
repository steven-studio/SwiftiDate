import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'analytics_manager_protocol.dart';

class AnalyticsManager implements AnalyticsManagerProtocol {
  // 單例
  static final AnalyticsManager shared = AnalyticsManager._internal();
  AnalyticsManager._internal();

  // FirebaseAnalytics 實例
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  // Mixpanel 實例，需在初始化時設定 Token
  Mixpanel? _mixpanel;

  // 初始化 Mixpanel，需要在應用程式啟動時呼叫一次
  Future<void> initializeMixpanel(String token) async {
    _mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
  }

  @override
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    // Firebase Analytics
    // 注意：Firebase Analytics 只接受 Map<String, Object?>
    final firebaseParams = <String, Object?>{};
    if (parameters != null) {
      for (final entry in parameters.entries) {
        // 只取能轉成 Firebase Analytics 支援的類型
        if (entry.value is String ||
            entry.value is num ||
            entry.value is bool) {
          firebaseParams[entry.key] = entry.value as Object;
        } else {
          // 其他型別可根據需求做轉換或直接略過
          print("Warning: Skip key=${entry.key} because value is not supported in Firebase Analytics");
        }
      }
    }
    await _firebaseAnalytics.logEvent(name: eventName, parameters: firebaseParams);

    // Mixpanel
    if (_mixpanel != null) {
      // Mixpanel 的 track 也需要 Map<String, dynamic>
      final mixpanelProps = <String, dynamic>{};
      if (parameters != null) {
        for (final entry in parameters.entries) {
          // Mixpanel 支援 string, num, bool, DateTime 等
          if (entry.value is String ||
              entry.value is num ||
              entry.value is bool ||
              entry.value is DateTime) {
            mixpanelProps[entry.key] = entry.value;
          } else {
            print("Warning: Skip key=${entry.key} in Mixpanel because value is not supported");
          }
        }
      }
      _mixpanel!.track(eventName, properties: mixpanelProps);
    } else {
      print("Warning: Mixpanel not initialized. Please call initializeMixpanel() first.");
    }

    // 在 Console 輸出
    print("Tracking Event: $eventName, params: $parameters");
  }
}
