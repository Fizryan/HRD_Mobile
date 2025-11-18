import 'package:hive/hive.dart';

// #region users
part '../generated/user_m.g.dart';

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  supervisor,
  @HiveField(2)
  hrd,
  @HiveField(3)
  finance,
  @HiveField(4)
  employee,
  @HiveField(5)
  unknown,
}

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String password;
  @HiveField(2)
  final UserRole role;
  @HiveField(3)
  final String name;
  @HiveField(4)
  double salary;

  User({
    required this.username,
    required this.password,
    required this.role,
    required this.name,
    this.salary = 0.0,
  });
}

// #endregion
