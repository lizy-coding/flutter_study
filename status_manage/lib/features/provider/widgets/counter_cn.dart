part of 'package:status_manage/features/provider/provider_route.dart';

/// ChangeNotifier 负责触发 `notifyListeners()`，Provider 会将它与 UI 解耦。
class CounterCN extends ChangeNotifier {
  int value = 0;
  int leafTaps = 0;

  void increment() {
    final before = value;
    value++;
    debugPrint('[Provider] increment: $before -> $value');
    notifyListeners();
  }

  void leafIncrement() {
    leafTaps++;
    debugPrint('[Provider] leaf tap -> $leafTaps (叶子直接调用 ChangeNotifier)');
    notifyListeners();
  }

  void reset() {
    value = 0;
    leafTaps = 0;
    debugPrint('[Provider] reset -> 0');
    notifyListeners();
  }
}
