import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/user_m.dart';

// #region user color
class UserColor {
  static Color getColorByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.supervisor:
        return Colors.blue;
      case UserRole.hrd:
        return Colors.green;
      case UserRole.finance:
        return Colors.orange;
      case UserRole.employee:
        return Colors.purple;
      case UserRole.unknown:
        return Colors.grey;
    }
  }

  static Color getTextColorByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColor.textSecColor;
      case UserRole.supervisor:
        return AppColor.textSecColor;
      case UserRole.hrd:
        return AppColor.textSecColor;
      case UserRole.finance:
        return AppColor.textSecColor;
      case UserRole.employee:
        return AppColor.textSecColor;
      case UserRole.unknown:
        return AppColor.textSecColor;
    }
  }
}

// #endregion

// #region application color
class AppColor {
  static const Color background = Color(0xFFF5F6FA);
  static const Color clipperBackground = Colors.red;
  static final Color borderShadow = Colors.black12;
  static const Color textColor = Color(0xFF1D1D1F);
  static const Color textSecColor = Color(0xFFE8EBF0);
  static const Color firstLinear = Color(0xFFb3d9ff);
  static const Color secondLinear = Color(0xFF80b3ff);
}

// #endregion

// #region status color
class StatusColor {
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color infoColor = Colors.blue;
}

// #endregion
