import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';

// #region login controller
class LoginController extends ChangeNotifier {
  LoginStatus _status = LoginStatus.initial;
  LoginStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  User? _loggedInUser;
  User? get loggedInUser => _loggedInUser;

  Future<void> login(String username, String password) async {
    _status = LoginStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final user = await UserService.getUser(username);
      if (user == null || user.password != password) {
        _status = LoginStatus.failed;
        _errorMessage = 'Invalid username or password';
      } else {
        _status = LoginStatus.success;
        _loggedInUser = user;
      }
    } catch (e) {
      _status = LoginStatus.failed;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _status = LoginStatus.initial;
    _errorMessage = '';
    _loggedInUser = null;
    notifyListeners();
  }

  void resetStatus() {
    _status = LoginStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
// #endregion