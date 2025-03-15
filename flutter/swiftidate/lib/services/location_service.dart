// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../analytics_manager.dart';

class LocationService {
  // Callback 供外部註冊：傳回最新位置
  Function(Position)? onLocationUpdate;
  // Callback 供外部註冊：傳回反向地理編碼的結果
  Function(Placemark)? onPlacemarkUpdate;

  // 開始取得位置更新並進行反向地理編碼
  Future<void> start() async {
    // 請求權限
    await Geolocator.requestPermission();
    // 開始位置更新
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen((position) {
      if (onLocationUpdate != null) {
        onLocationUpdate!(position);
      }
      AnalyticsManager.shared.trackEvent("location_update", parameters: {
        "latitude": position.latitude,
        "longitude": position.longitude,
      });
      _reverseGeocode(position);
    });
  }

  Future<void> _reverseGeocode(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        if (onPlacemarkUpdate != null) {
          onPlacemarkUpdate!(placemark);
        }
        AnalyticsManager.shared.trackEvent("reverse_geocode_success", parameters: {
          "country": placemark.country ?? "unknown",
          "locality": placemark.locality ?? "unknown",
          "coordinate": "${position.latitude},${position.longitude}",
        });
      }
    } catch (error) {
      print("Reverse geocode failed: $error");
      AnalyticsManager.shared.trackEvent("reverse_geocode_failed", parameters: {
        "error": error.toString(),
      });
    }
  }

  // 若需要停止更新，可加入取消訂閱的邏輯
}
