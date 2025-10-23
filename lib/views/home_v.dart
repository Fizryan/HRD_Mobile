import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/widgets/admin_w.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final User user;
  const HomeView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard ${user.displayRole}"),
        backgroundColor: ColorUser().getColor(user.role),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginControl>().logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hallo! ${user.displayName}',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildPanel(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context, User user) {
    switch (user.role) {
      case UserRole.admin:
        return AdminPanel(user: user);
      case UserRole.supervisor:
        throw UnimplementedError();
      case UserRole.hrd:
        throw UnimplementedError();
      case UserRole.finance:
        throw UnimplementedError();
      case UserRole.employee:
        throw UnimplementedError();
      case UserRole.unknown:
        return const Text('Role tidak dikenali. Hubungi admin.');
    }
  }
}
