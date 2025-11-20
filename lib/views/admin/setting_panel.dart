import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:provider/provider.dart';

class SettingPanel extends StatefulWidget {
  const SettingPanel({super.key});

  @override
  State<SettingPanel> createState() => _SettingPanelState();
}

class _SettingPanelState extends State<SettingPanel> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("General Configuration"),
            _buildCardContainer(children: []),
            const SizedBox(height: 24),
            _buildSectionHeader("Security"),
            _buildCardContainer(children: []),
            const SizedBox(height: 24),
            _buildSectionHeader("Data Management", isDanger: true),
            _buildCardContainer(
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh, color: Colors.orange),
                  title: const Text("Reload Data"),
                  subtitle: const Text("Force refresh from Hive storage"),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).loadUsers();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text("Data reloaded successfully"),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(
                    Icons.restore_page_outlined,
                    color: Colors.blue,
                  ),
                  title: const Text("Seed Dummy Data"),
                  subtitle: const Text("Reset & fill with sample users"),
                  onTap: () => _showSeedConfirmDialog(context),
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    "Wipe Database",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("Permanently delete all users"),
                  onTap: () => _showWipeConfirmDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "HRD System v1.0.0\nBuild ${DateTime.now().year}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDanger ? Colors.red : Colors.grey[700],
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: 16,
      endIndent: 16,
    );
  }

  void _showWipeConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("⚠️ Danger Zone"),
        content: const Text(
          "Are you sure you want to delete ALL user data? This action cannot be undone.",
        ),
        backgroundColor: AppColor.background,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColor.textColor),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              final provider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              await provider.clearAllUsers();
              if (!mounted) return;
              messenger.showSnackBar(
                const SnackBar(content: Text("Database wiped successfully.")),
              );
            },
            child: const Text("WIPE DATA"),
          ),
        ],
      ),
    );
  }

  void _showSeedConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset & Seed Data"),
        content: const Text(
          "This will clear current data and replace it with Dummy Users (Fizryan, Naufal, etc).",
        ),
        backgroundColor: AppColor.background,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColor.textColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.secondLinear,
            ),
            onPressed: () async {
              final provider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              await provider.clearAllUsers();
              await provider.addUserList(dummyUsers);
              if (!mounted) return;
              messenger.showSnackBar(
                const SnackBar(content: Text("Data reset to defaults.")),
              );
            },
            child: const Text(
              "Reset & Seed",
              style: TextStyle(color: AppColor.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
