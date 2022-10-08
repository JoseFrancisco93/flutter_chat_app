import 'package:flutter/material.dart';

class Globals extends ChangeNotifier {
  bool isFalse = false;

  bool get isNormal => isFalse == false;

  void toLoginSetTrue() {
    isFalse = true;
    notifyListeners();
  }

  void toLoginSetFalse() {
    isFalse = false;
    notifyListeners();
  }
}