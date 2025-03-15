import 'package:flutter/foundation.dart';

class ConsumableStore extends ChangeNotifier {
  int consumableCount = 0;

  void addConsumable() {
    consumableCount++;
    notifyListeners();
  }

  void resetConsumables() {
    consumableCount = 0;
    notifyListeners();
  }
}
