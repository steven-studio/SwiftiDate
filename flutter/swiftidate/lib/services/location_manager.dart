// lib/services/location_manager.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../analytics_manager.dart';

class LocationManager extends ChangeNotifier {
  Position? userLocation;
  LocationPermission? authorizationStatus;
  bool hasLoggedLocationEvent = false;

  // Stream subscription 可用來停止更新（若需要）
  late final Stream<Position> _positionStream;

  LocationManager() {
    _init();
  }

  Future<void> _init() async {
    await requestPermission();
    authorizationStatus = await Geolocator.checkPermission();
    notifyListeners();

    // 開始訂閱位置更新
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
    _positionStream.listen((position) {
      userLocation = position;
      notifyListeners();
      if (!hasLoggedLocationEvent) {
        hasLoggedLocationEvent = true;
        AnalyticsManager.shared.trackEvent("location_update_first_time", parameters: {
          "latitude": position.latitude,
          "longitude": position.longitude,
        });
      }
    });
  }

  Future<void> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    authorizationStatus = permission;
    notifyListeners();
  }

  // 若需要停止更新，可加入取消訂閱的邏輯
}
