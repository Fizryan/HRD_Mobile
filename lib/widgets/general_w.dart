import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';

class GeneralWidget {
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

  Widget buildSystemInfo(List<Widget> widgetsChildrens) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'System Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: widgetsChildrens,
            ),
          ],
        ),
      ),
    );
  }

  List<Card> toDoInfoChildrens(
    String titleText,
    String subtitleText,
    int randomInt,
    Icon iconUser,
    User user,
    TabController tabController,
  ) => <Card>[
    Card(
      elevation: 4,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.pending_actions,
          color: Colors.orange,
          size: 32,
        ),
        title: Text(titleText, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$randomInt, $subtitleText"),
        trailing: iconUser,
        onTap: () {
          if (titleText == "Pengajuan Cuti" && user.role == UserRole.hrd) {
            tabController.animateTo(1);
          }
        },
      ),
    ),
  ];
}
