import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';

Widget buildStatsHeader(List<Widget> widgetsChildrens, User user) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: ColorUser().getColor(user.role), width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgetsChildrens,
      ),
    ),
  );
}

Widget buildInfoCard(
  String title,
  String value,
  IconData icon,
  Color color,
  BuildContext context,
) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
