import 'package:hrd_system_project/models/user_m.dart';

final List<User> dummyUsers = [
  User(
    username: "fizryan",
    password: "admin",
    name: "Fizryan",
    role: UserRole.admin,
    salary: 10000000.0,
  ),
  User(
    username: "naufal",
    password: "admin",
    name: "Naufal",
    role: UserRole.supervisor,
    salary: 8000000.0,
  ),
  User(
    username: "haidar",
    password: "admin",
    name: "Haidar",
    role: UserRole.hrd,
    salary: 7500000.0,
  ),
  User(
    username: "fathir",
    password: "admin",
    name: "Fathir",
    role: UserRole.finance,
    salary: 12000000.0,
  ),
  User(
    username: "cecep",
    password: "admin",
    name: "Cecep",
    role: UserRole.employee,
    salary: 5000000.0,
  ),
];

class UserList {
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
