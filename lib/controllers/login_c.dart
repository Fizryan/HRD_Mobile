import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/login_m.dart';
import 'package:hrd_system_project/models/user_m.dart';

class LoginControl extends ChangeNotifier {
  LoginStatus _loginStatus = LoginStatus.initial;
  String _errorMessage = '';
  User? _loggedInUser;

  LoginStatus get loginStatus => _loginStatus;
  String get errorMessage => _errorMessage;
  User? get loggedInUser => _loggedInUser;

  Future<void> login(String username, String password) async {
    _loginStatus = LoginStatus.loading;
    _errorMessage = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 0));

    final userFound = dummyUsers.firstWhereOrNull(
      (user) => user.username == username && user.password == password,
    );

    if (userFound != null) {
      _loginStatus = LoginStatus.success;
      _loggedInUser = userFound;
    } else {
      _loginStatus = LoginStatus.failed;
      _errorMessage = 'Invalid username or password';
    }

    notifyListeners();
  }

  void logout() {
    _loginStatus = LoginStatus.initial;
    _errorMessage = '';
    _loggedInUser = null;
    notifyListeners();
  }
}
