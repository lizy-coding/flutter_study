// models/counter_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CounterModel extends ChangeNotifier {
  int count;

  CounterModel({this.count = 0});

  void increment() {
    count++;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
    };
  }

  factory CounterModel.fromMap(Map<String, dynamic> map) {
    return CounterModel(
      count: map['count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CounterModel.fromJson(String source) =>
      CounterModel.fromMap(json.decode(source));
}
