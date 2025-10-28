import 'package:hrd_system_project/models/user_m.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserList {
  static const String _keyUsers = 'users';

  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> userJsonList = users
        .map((user) => jsonEncode(user.toJson()))
        .toList();

    await prefs.setStringList(_keyUsers, userJsonList);
  }

  static Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonList = prefs.getStringList(_keyUsers);

    if (userJsonList == null) return [];

    return userJsonList.map((jsonStr) {
      final userMap = jsonDecode(jsonStr);
      return User.fromJson(userMap);
    }).toList();
  }

  static Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsers);
  }

  static Future<void> addUser(User user) async {
    final users = await loadUsers();
    users.add(user);
    await saveUsers(users);
  }

  static Future<void> removeUser(User user) async {
    final users = await loadUsers();
    users.removeWhere((u) => u.username == user.username);
    await saveUsers(users);
  }

  static Future<void> updateUser(User user) async {
    final users = await loadUsers();
    final index = users.indexWhere((u) => u.username == user.username);
    if (index != -1) {
      users[index] = user;
      await saveUsers(users);
    }
  }

  static Future<List<User>> getAllUsers() async {
    List<User> users = await loadUsers();
    if (users.isEmpty) {
      await saveUsers(dummyUsers);
      return dummyUsers;
    }
    return users;
  }

  static Future<List<User>> getFilteredUsers(String query) async {
    final users = await getAllUsers();
    final filteredUsers = users
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.role.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return filteredUsers;
  }

  static Future<void> clearAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsers);
  }
}

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
  // 5
  User(
    username: "andi",
    password: "admin",
    name: "Andi",
    role: UserRole.employee,
    salary: 5500000.0,
  ),
  // 6
  User(
    username: "bunga",
    password: "admin",
    name: "Bunga",
    role: UserRole.employee,
    salary: 6000000.0,
  ),
  // 7
  User(
    username: "dewi",
    password: "admin",
    name: "Dewi",
    role: UserRole.employee,
    salary: 6500000.0,
  ),
  // 8
  User(
    username: "eko",
    password: "admin",
    name: "Eko",
    role: UserRole.employee,
    salary: 7000000.0,
  ),
  // 9
  User(
    username: "ahmad",
    password: "admin",
    name: "Ahmad",
    role: UserRole.employee,
    salary: 7500000.0,
  ),
  // 10
  User(
    username: "bella",
    password: "admin",
    name: "Bella",
    role: UserRole.employee,
    salary: 8000000.0,
  ),
  // 11
  User(
    username: "chandra",
    password: "admin",
    name: "Chandra",
    role: UserRole.employee,
    salary: 8500000.0,
  ),
  // 12
  User(
    username: "dina",
    password: "admin",
    name: "Dina",
    role: UserRole.employee,
    salary: 9000000.0,
  ),
  // 13
  User(
    username: "farhan",
    password: "admin",
    name: "Farhan",
    role: UserRole.employee,
    salary: 9500000.0,
  ),
];