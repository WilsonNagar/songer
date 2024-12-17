import 'package:flutter/foundation.dart';

class SingleProvider<T> extends ChangeNotifier {
  T _value;

  SingleProvider(this._value);

  // Getter for the current value
  T get value => _value;

  // Setter to update the value and notify listeners
  void update(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
