import 'package:flutter_test/flutter_test.dart';
import 'package:status_manage/features/provider/models/counter_cn.dart';

void main() {
  group('CounterCN', () {
    test('initial values', () {
      final cn = CounterCN();
      expect(cn.value, 0);
      expect(cn.leafTaps, 0);
    });

    test('increment updates value and notifies', () {
      final cn = CounterCN();
      var notified = 0;
      cn.addListener(() => notified++);
      cn.increment();
      expect(cn.value, 1);
      expect(notified, 1);
    });

    test('leafIncrement updates leafTaps and notifies', () {
      final cn = CounterCN();
      var notified = 0;
      cn.addListener(() => notified++);
      cn.leafIncrement();
      expect(cn.leafTaps, 1);
      expect(notified, 1);
    });

    test('reset sets both fields to zero and notifies', () {
      final cn = CounterCN();
      var notified = 0;
      cn.addListener(() => notified++);
      cn.increment();
      cn.leafIncrement();
      cn.reset();
      expect(cn.value, 0);
      expect(cn.leafTaps, 0);
      expect(notified >= 1, true);
    });
  });
}

