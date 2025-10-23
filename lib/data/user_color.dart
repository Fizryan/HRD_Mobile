import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/user_m.dart';

class ColorUser {
  static const MaterialColor adminColor = Colors.red;
  static const MaterialColor supervisorColor = Colors.pink;
  static const MaterialColor hrdColor = Colors.blue;
  static const MaterialColor financeColor = Colors.green;
  static const MaterialColor employeeColor = Colors.purple;
  static const MaterialColor unknownColor = Colors.grey;

  Color getColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return adminColor;
      case UserRole.supervisor:
        return supervisorColor;
      case UserRole.hrd:
        return hrdColor;
      case UserRole.finance:
        return financeColor;
      case UserRole.employee:
        return employeeColor;
      default:
        return unknownColor;
    }
  }
}
