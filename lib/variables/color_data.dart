import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/user_m.dart';

// #region user color
class UserColor {
  static const Color adminColor = Colors.red;
  static const Color supervisorColor = Colors.blue;
  static const Color hrdColor = Colors.green;
  static const Color financeColor = Colors.orange;
  static const Color employeeColor = Colors.purple;
  static const Color unknownColor = Colors.grey;

  static Color getColorByRole(UserRole role) {
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
      case UserRole.unknown:
        return unknownColor;
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
  // Background colors
  static const Color background = Color(0xFFF5F6FA);
  static const Color white = Colors.white;
  static const Color clipperBackground = Colors.red;

  // Text colors
  static const Color textColor = Color(0xFF1D1D1F);
  static const Color textSecColor = Color(0xFFE8EBF0);

  // Border and shadow colors
  static const Color borderShadow = Colors.black12;

  // Gradient colors
  static const Color firstLinear = Color(0xFFb3d9ff);
  static const Color secondLinear = Color(0xFF80b3ff);

  // Button colors
  static const Color buttonPrimary = Color(0xFF007BFF);
  static const Color buttonPrimaryDark = Color(0xFF0056B3);

  // Grey variants
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color greyDefault = Colors.grey;

  // Blue variants
  static const Color blueGrey = Colors.blueGrey;

  // Specific colors
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color orange = Colors.orange;
  static const Color blue = Colors.blue;
  static const Color black87 = Colors.black87;
  static const Color transparent = Colors.transparent;
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
