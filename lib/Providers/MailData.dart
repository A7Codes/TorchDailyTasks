import 'package:flutter/material.dart';

class MailData extends ChangeNotifier {
  String username = "";
  String password = "";

  void setCreds(String un, String pa) {
    username = un;
    password = pa;
    notifyListeners();
  }
}
