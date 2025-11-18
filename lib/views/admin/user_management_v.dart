import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:provider/provider.dart';

class UserManagementView extends StatefulWidget {
  final User currentUser;

  const UserManagementView({super.key, required this.currentUser});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final filteredUsers = userProvider.users.where((user) {
          final nameLower = user.name.toLowerCase();
          final usernameLower = user.username.toLowerCase();
          final roleLower = user.role.name.toLowerCase();
          final searchLower = _searchQuery.toLowerCase();

          return nameLower.contains(searchLower) ||
              usernameLower.contains(searchLower) ||
              roleLower.contains(searchLower);
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        );
      },
    );
  }
}
