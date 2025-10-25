import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/user_m.dart';

class HrdController extends ChangeNotifier {
  List<User> _employeeList = [];
  List<User> get employeeList => _employeeList;

  HrdController() {
    _loadEmployee();
  }

  void _loadEmployee() {
    _employeeList = dummyUsers
        .where(
          (user) =>
              user.role == UserRole.employee ||
              user.role == UserRole.supervisor ||
              user.role == UserRole.finance,
        )
        .toList();
  }

  void addUser({
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
  }) {
    final newUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );
    _employeeList.add(newUser);
    notifyListeners();
  }

  void updateUser({
    required User userToEdit,
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
  }) {
    final int index = _employeeList.indexOf(userToEdit);
    if (index != -1) return;
    final updateUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );

    _employeeList[index] = updateUser;
    notifyListeners();
  }

  void deleteUser(User user) {
    _employeeList.remove(user);
    notifyListeners();
  }
}
