import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/controllers/expense_c.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:hrd_system_project/views/admin/wipe_data_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingPanel extends StatefulWidget {
  const SettingPanel({super.key});

  @override
  State<SettingPanel> createState() => _SettingPanelState();
}

class _SettingPanelState extends State<SettingPanel> {
  late String _appVersion;

  @override
  void initState() {
    super.initState();
    _appVersion = 'Loading...';
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = 'v${packageInfo.version}+${packageInfo.buildNumber}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appVersion = 'v1.0.0+1';
        });
      }
    }
  }

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
            _buildSectionHeader("User Data Management", isDanger: true),
            _buildCardContainer(
              children: [
                _buildSettingTile(
                  icon: Icons.refresh,
                  iconColor: StatusColor.warningColor,
                  title: "Reload User Data",
                  subtitle: "Force refresh users from Hive storage",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.warningColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(
                        color: StatusColor.warningColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (!mounted) return;
                    final messenger = ScaffoldMessenger.of(context);
                    final userProvider = context.read<UserProvider>();

                    await userProvider.loadUsers();

                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColor.white),
                            SizedBox(width: 8),
                            Text("User data reloaded successfully"),
                          ],
                        ),
                        backgroundColor: StatusColor.successColor,
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
                  iconColor: StatusColor.infoColor,
                  title: "Seed User Dummy Data",
                  subtitle: "Reset & fill with sample users",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.infoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Seed",
                      style: TextStyle(
                        color: StatusColor.infoColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => _showSeedUserConfirmDialog(context),
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.delete_forever,
                  iconColor: StatusColor.errorColor,
                  title: "Wipe User Database",
                  subtitle: "Permanently delete all users",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: StatusColor.errorColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: StatusColor.errorColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => _showWipeUserConfirmDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader("Expense Data Management", isDanger: true),
            _buildCardContainer(
              children: [
                _buildSettingTile(
                  icon: Icons.refresh,
                  iconColor: StatusColor.warningColor,
                  title: "Reload Expense Data",
                  subtitle: "Force refresh expenses from Hive storage",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.warningColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(
                        color: StatusColor.warningColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (!mounted) return;
                    final messenger = ScaffoldMessenger.of(context);
                    final expenseProvider = context.read<ExpenseProvider>();

                    await expenseProvider.loadExpenses();

                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColor.white),
                            SizedBox(width: 8),
                            Text("Expense data reloaded successfully"),
                          ],
                        ),
                        backgroundColor: StatusColor.successColor,
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
                  iconColor: StatusColor.infoColor,
                  title: "Seed Expense Dummy Data",
                  subtitle: "Reset & fill with sample expenses",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.infoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Seed",
                      style: TextStyle(
                        color: StatusColor.infoColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => _showSeedExpenseConfirmDialog(context),
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.delete_forever,
                  iconColor: StatusColor.errorColor,
                  title: "Wipe Expense Database",
                  subtitle: "Permanently delete all expenses",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: StatusColor.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: StatusColor.errorColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: StatusColor.errorColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => _showWipeExpenseConfirmDialog(context),
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
            "HR-Connect Admin System",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _appVersion,
            style: const TextStyle(
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

  void _showWipeUserConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WipeDataDialog(
        title: "Wipe User Database",
        content:
            "Are you sure you want to delete ALL user data? This action cannot be undone.",
        onConfirm: () async {
          if (!mounted) return;
          final provider = context.read<UserProvider>();
          final messenger = ScaffoldMessenger.of(context);

          await provider.clearAllUsers();

          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.delete_forever, color: AppColor.white),
                  SizedBox(width: 8),
                  Text("User database wiped successfully"),
                ],
              ),
              backgroundColor: StatusColor.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSeedUserConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: StatusColor.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restore_page_outlined,
                color: StatusColor.infoColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Reset & Seed User Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "This will clear current user data and replace it with Dummy Users.",
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
              backgroundColor: StatusColor.infoColor,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              if (!mounted) return;
              final provider = context.read<UserProvider>();
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
                      Text("User data reset to defaults"),
                    ],
                  ),
                  backgroundColor: StatusColor.infoColor,
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

  void _showWipeExpenseConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => WipeDataDialog(
        title: "Wipe Expense Database",
        content:
            "Are you sure you want to delete ALL expense data? This action cannot be undone.",
        onConfirm: () async {
          final provider = Provider.of<ExpenseProvider>(context, listen: false);
          final messenger = ScaffoldMessenger.of(context);
          await provider.clearAllExpenses();
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.delete_forever, color: AppColor.white),
                  SizedBox(width: 8),
                  Text("Expense database wiped successfully"),
                ],
              ),
              backgroundColor: StatusColor.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSeedExpenseConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: StatusColor.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restore_page_outlined,
                color: StatusColor.infoColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Reset & Seed Expense Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "This will clear current expense data and replace it with sample expenses.",
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
              backgroundColor: StatusColor.infoColor,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              if (!mounted) return;
              final provider = context.read<ExpenseProvider>();
              final messenger = ScaffoldMessenger.of(context);

              Navigator.pop(ctx);

              await provider.clearAllExpenses();
              await provider.addExpenseList(dummyExpenses);

              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColor.white),
                      SizedBox(width: 8),
                      Text("Expense data reset to defaults"),
                    ],
                  ),
                  backgroundColor: StatusColor.infoColor,
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
