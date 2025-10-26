import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/user_m.dart';

class HrdController extends ChangeNotifier {
  List<User> _employeeList = [];
  List<User> get employeeList => _employeeList;

  HrdController() {
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    _employeeList = await UserList.getAllUsers();
    _employeeList = _employeeList
        .where(
          (user) =>
              user.role == UserRole.employee ||
              user.role == UserRole.supervisor ||
              user.role == UserRole.finance ||
              user.role == UserRole.admin,
        )
        .toList();
    notifyListeners();
  }

  Future<void> addUser({
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
  }) async {
    final newUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );
    await UserList.addUser(newUser);
    await _loadEmployee();
  }

  Future<void> updateUser({
    required User userToEdit,
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
  }) async {
    final updateUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );

    await UserList.updateUser(updateUser);
    await _loadEmployee();
  }

  Future<void> deleteUser(User user) async {
    await UserList.removeUser(user);
    await _loadEmployee();
  }
}
