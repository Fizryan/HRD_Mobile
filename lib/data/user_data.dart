import 'package:hrd_system_project/models/user_m.dart';

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

class UserList {
  static List<User> getAllUsers() {
    return dummyUsers;
  }

  static List<User> getFilteredUsers(String query) {
    final filteredUsers = dummyUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.displayRole.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return filteredUsers;
  }
}
