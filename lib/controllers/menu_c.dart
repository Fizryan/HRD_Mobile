import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/menu_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/views/admin/admin_panel.dart';
import 'package:hrd_system_project/views/admin/setting_panel.dart';
import 'package:hrd_system_project/views/admin/user_management_v.dart';

// #region menu config
class MenuConfig {
  static List<NavigationItem> getMenusForRole(User user) {
    switch (user.role) {
      case UserRole.admin:
        return [
          NavigationItem(
            label: 'Dashboard',
            icon: Icons.dashboard,
            page: AdminPanel(user: user),
          ),
          NavigationItem(
            label: 'User Management',
            icon: Icons.manage_accounts_outlined,
            page: UserManagementView(currentUser: user),
          ),
          NavigationItem(
            label: 'Settings',
            icon: Icons.settings,
            page: SettingPanel(),
          ),
        ];
      case UserRole.supervisor:
        return [];
      case UserRole.hrd:
        return [];
      case UserRole.finance:
        return [];
      case UserRole.employee:
        return [];
      case UserRole.unknown:
        return [];
    }
  }
}
// #endregion