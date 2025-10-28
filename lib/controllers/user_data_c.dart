import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/log_c.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/log_m.dart';
import 'package:hrd_system_project/models/user_m.dart';

class UserController extends ChangeNotifier {
  List<User> _employeeList = [];
  List<User> get employeeList => _employeeList;
  final LogController logController;

  UserController(this.logController) {
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    _employeeList = await UserList.getAllUsers();
    notifyListeners();
  }

  Future<void> addUser({
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
    required String actorName,
  }) async {
    final newUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );
    await UserList.addUser(newUser);
    await logController.addLog(actorName, LogAction.createUser, 'User ${newUser.name} created');
    await _loadEmployee();
  }

  Future<void> updateUser({
    required User userToEdit,
    required String username,
    required String password,
    required String name,
    required UserRole role,
    required double salary,
    required String actorName,
  }) async {
    String changes = '';
    if (userToEdit.name != name) {
      changes += 'name from ${userToEdit.name} to $name, ';
    }
    if (userToEdit.role != role) {
      changes += 'role from ${userToEdit.role.name} to ${role.name}, ';
    }
    if (userToEdit.salary != salary) {
      changes += 'salary from ${userToEdit.salary} to $salary, ';
    }

    if (changes.isNotEmpty) {
      changes = changes.substring(0, changes.length - 2);
    }

    final updatedUser = User(
      username: username,
      password: password,
      name: name,
      role: role,
      salary: salary,
    );

    await UserList.updateUser(updatedUser);
    await logController.addLog(actorName, LogAction.updateUser, 'User ${userToEdit.name} updated: $changes');
    await _loadEmployee();
  }

  Future<void> deleteUser(User user, String actorName) async {
    await UserList.removeUser(user);
    await logController.addLog(actorName, LogAction.deleteUser, 'User ${user.name} deleted');
    await _loadEmployee();
  }

  Future<void> clearAllData(String actorName) async {
    await UserList.clearAllUsers();
    await logController.addLog(actorName, LogAction.clearData, 'All user data cleared');
    await _loadEmployee();
  }
}