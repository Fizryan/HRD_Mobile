import 'package:hrd_system_project/models/user_m.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

// #region user service
class UserService {
  static const String _userBoxName = 'users';
  static Box<User>? _userBox;

  static Future<Box<User>> _openBox() async {
    _userBox ??= await Hive.openBox<User>(_userBoxName);
    return _userBox!;
  }

  static Future<void> initialize() async {
    final box = await _openBox();
    await box.clear();
  }

  static Future<void> addUserList(List<User> users) async {
    final box = await _openBox();
    for (final user in users) {
      await box.put(user.username, user);
    }
  }

  static Future<void> addUser(User user) async {
    final box = await _openBox();
    await box.put(user.username, user);
  }

  static Future<List<User>> getAllUsers() async {
    final box = await _openBox();
    return box.values.toList();
  }

  static Future<User?> getUser(String username) async {
    final box = await _openBox();
    return box.get(username);
  }

  static Future<void> updateUser(User user) async {
    final box = await _openBox();
    await box.put(user.username, user);
  }

  static Future<void> deleteUser(String username) async {
    final box = await _openBox();
    await box.delete(username);
  }

  static Future<void> clearAllUsers() async {
    final box = await _openBox();
    await box.clear();
  }

  static Future<void> resetBox() async {
    if (_userBox?.isOpen ?? false) {
      await _userBox!.close();
    }
    await Hive.deleteBoxFromDisk(_userBoxName);
    _userBox = null;
    await _openBox();
  }

  static Future<void> seedUsers(List<User> users) async {
    final box = await _openBox();

    if (box.isEmpty) {
      for (final user in users) {
        await box.put(user.username, user);
      }
    }
  }
}

// #endregion

// #region user provider
class UserProvider extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> initialize() async {
    await UserService.initialize();
    await loadUsers();
  }

  Future<void> loadUsers() async {
    _users = await UserService.getAllUsers();
    notifyListeners();
  }

  Future<void> addUserList(List<User> users) async {
    await UserService.addUserList(users);
    _users.addAll(users);
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await UserService.addUser(user);
    _users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await UserService.updateUser(user);
    await loadUsers();
  }

  Future<void> deleteUser(String username) async {
    await UserService.deleteUser(username);
    await loadUsers();
  }

  Future<void> clearAllUsers() async {
    await UserService.clearAllUsers();
    await loadUsers();
  }

  Future<void> resetBox() async {
    await UserService.resetBox();
    await loadUsers();
  }
}
// #endregion

// #region dummy
final List<User> dummyUsers = [
  // 0
  User(
    username: "fizryan",
    password: "admin",
    name: "Fizryan",
    role: UserRole.admin,
    salary: 10000000.0,
  ),
  // 1
  User(
    username: "naufal",
    password: "admin",
    name: "Naufal",
    role: UserRole.supervisor,
    salary: 8000000.0,
  ),
  // 2
  User(
    username: "haidar",
    password: "admin",
    name: "Haidar",
    role: UserRole.hrd,
    salary: 7500000.0,
  ),
  // 3
  User(
    username: "fathir",
    password: "admin",
    name: "Fathir",
    role: UserRole.finance,
    salary: 12000000.0,
  ),
  // 4
  User(
    username: "cecep",
    password: "admin",
    name: "Cecep",
    role: UserRole.employee,
    salary: 5000000.0,
  ),
];
// #endregion
