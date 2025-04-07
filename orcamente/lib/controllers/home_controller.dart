import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  String _appBarTitle = 'Olá, Antônio';
  String get appBarTitle => _appBarTitle;

  bool _titleChanged = false;

  void initTitleChange() {
    if (_titleChanged) return;

    Future.delayed(const Duration(seconds: 4), () {
      _appBarTitle = 'OrçaMente';
      _titleChanged = true;
      notifyListeners();
    });
  }
}
