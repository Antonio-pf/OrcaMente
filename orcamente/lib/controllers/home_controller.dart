import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../core/result.dart';

class HomeController extends ChangeNotifier {
  final UserRepository _userRepository;

  String _appBarTitle = 'Olá';
  String _userName = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _titleChanged = false;

  HomeController(this._userRepository) {
    _initialize();
  }

  // Getters
  String get appBarTitle => _appBarTitle;
  String get userName => _userName;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Initialize controller by loading user data
  Future<void> _initialize() async {
    await loadUserData();
    initTitleChange();
  }

  /// Load user data from repository
  Future<Result<void>> loadUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _userRepository.getUserData();

    result.when(
      success: (userData) {
        _userName = userData['nome'] ?? '';
        if (_userName.isNotEmpty) {
          _appBarTitle = 'Olá, $_userName';
        } else {
          _appBarTitle = 'Olá';
        }
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _appBarTitle = 'Olá';
        _isLoading = false;
        notifyListeners();
      },
    );

    return result.map((_) => null);
  }

  /// Animate title change from greeting to app name
  void initTitleChange() {
    if (_titleChanged) return;

    Future.delayed(const Duration(seconds: 4), () {
      _appBarTitle = 'OrçaMente';
      _titleChanged = true;
      notifyListeners();
    });
  }

  /// Reload user data
  Future<Result<void>> refresh() async {
    _titleChanged = false;
    return await loadUserData();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
