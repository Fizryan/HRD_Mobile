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

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'name': name,
    'role': role.name,
    'salary': salary,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
    password: json['password'],
    name: json['name'],
    role: UserRole.values.firstWhere((role) => role.name == json['role']),
    salary: json['salary']?.toDouble() ?? 0.0,
  );
}
