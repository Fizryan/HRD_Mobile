enum UserRole { admin, supervisor, hrd, finance, employee, unknown }

class User {
  final String username;
  final String password;
  final String name;
  final UserRole role;
  double salary;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.salary = 0.0,
  });

  String get displayName {
    return name;
  }

  String get displayRole {
    return role.toString().split('.').last;
  }
}
