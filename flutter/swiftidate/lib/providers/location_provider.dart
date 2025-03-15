// lib/providers/location_provider.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../analytics/analytics_manager.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  LocationPermission? _permission;
  bool hasLoggedFirstLocation = false;

  Position? get currentPosition => _currentPosition;
  LocationPermission? get permission => _permission;

  LocationProvider() {
    _initLocation();
  }

  Future<void> _initLocation() async {
    // 請求權限
    _permission = await Geolocator.requestPermission();
    notifyListeners();

    // 開始位置更新
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen((position) {
      _currentPosition = position;
      notifyListeners();

      // 第一次更新時上報事件
      if (!hasLoggedFirstLocation) {
        hasLoggedFirstLocation = true;
        AnalyticsManager.shared.trackEvent("location_update_first_time", parameters: {
          "latitude": position.latitude,
          "longitude": position.longitude,
        });
      }
    });
  }
}
