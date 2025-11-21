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
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildSectionHeader("General Configuration"),
            _buildCardContainer(
              children: [
                _buildSettingTile(
                  icon: Icons.palette_outlined,
                  iconColor: AppColor.blue,
                  title: "Appearance",
                  subtitle: "Customize theme and colors",
                  trailing: const Text(
                    "System",
                    style: TextStyle(
                      color: AppColor.grey600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.language_outlined,
                  iconColor: AppColor.green,
                  title: "Language",
                  subtitle: "Choose your preferred language",
                  trailing: const Text(
                    "English",
                    style: TextStyle(
                      color: AppColor.grey600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader("Data Management", isDanger: true),
            _buildCardContainer(
              children: [
                _buildSettingTile(
                  icon: Icons.refresh,
                  iconColor: AppColor.orange,
                  title: "Reload Data",
                  subtitle: "Force refresh from Hive storage",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(
                        color: AppColor.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).loadUsers();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColor.white),
                            SizedBox(width: 8),
                            Text("Data reloaded successfully"),
                          ],
                        ),
                        backgroundColor: AppColor.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.restore_page_outlined,
                  iconColor: AppColor.blue,
                  title: "Seed Dummy Data",
                  subtitle: "Reset & fill with sample users",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Seed",
                      style: TextStyle(
                        color: AppColor.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => _showSeedConfirmDialog(context),
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.delete_forever,
                  iconColor: AppColor.red,
                  title: "Wipe Database",
                  subtitle: "Permanently delete all users",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColor.red.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => _showWipeConfirmDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildAboutSection(),
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
          color: isDanger ? AppColor.red : AppColor.grey700,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.buttonPrimary, AppColor.buttonPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blue.withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: AppColor.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your preferences and data",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColor.textColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColor.grey600),
        ),
      ),
      trailing: trailing,
    );
  }

  Widget _buildAboutSection() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey200, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.buttonPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business_center,
              color: AppColor.buttonPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "HRD System",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Version 1.0.0",
            style: TextStyle(
              fontSize: 13,
              color: AppColor.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.grey50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColor.grey600,
                ),
                const SizedBox(width: 6),
                Text(
                  "Build ${DateTime.now().year}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.greyDefault.withValues(alpha: 0.05),
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
      color: AppColor.grey100,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showWipeConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColor.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Danger Zone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete ALL user data? This action cannot be undone.",
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: AppColor.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColor.grey600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete_forever, color: AppColor.white),
                      SizedBox(width: 8),
                      Text("Database wiped successfully"),
                    ],
                  ),
                  backgroundColor: AppColor.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text(
              "WIPE DATA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSeedConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restore_page_outlined,
                color: AppColor.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Reset & Seed Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "This will clear current data and replace it with Dummy Users (Fizryan, Naufal, etc).",
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: AppColor.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColor.grey600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.blue,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColor.white),
                      SizedBox(width: 8),
                      Text("Data reset to defaults"),
                    ],
                  ),
                  backgroundColor: AppColor.blue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text(
              "Reset & Seed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
