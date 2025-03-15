import 'dart:convert';
import 'package:http/http.dart' as http;

class IPManager {
  // 單例模式
  static final IPManager shared = IPManager._internal();
  IPManager._internal();

  /// 取得對外 IP，若成功回傳 IP 字串，否則回傳 null
  Future<String?> fetchPublicIP() async {
    try {
      final response = await http.get(Uri.parse("https://api.ipify.org?format=json"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["ip"] as String?;
      } else {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching public IP: $e");
      return null;
    }
  }
}
