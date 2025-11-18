import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';

class AdminPanel extends StatefulWidget {
  final User user;
  const AdminPanel({super.key, required this.user});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _usersFuture = UserService.getAllUsers();
    });
  }

  String _formatCurrency(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final users = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 20),
                // _buildTabSelector(theme),
                // const SizedBox(height: 20),
                _buildFinancialSummary(users),
                const SizedBox(height: 20),
                Text(
                  "Overview Statistics",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatsGrid(users),
                const SizedBox(height: 24),
                Text(
                  "New Joiners",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildUserListPreview(users, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcom back',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColor.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
            ),
            Text(
              widget.user.role.name.toUpperCase(),
              style: TextStyle(
                color: UserColor.getColorByRole(widget.user.role),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person_outline_rounded, color: Colors.white),
        ),
      ],
    );
  }

  // Widget _buildTabSelector(ThemeData theme) {
  //   return Container(
  //     height: 45,
  //     decoration: BoxDecoration(
  //       color: AppColor.firstLinear,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: TabBar(
  //       controller: _tabController,
  //       indicator: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         color: AppColor.secondLinear,
  //       ),
  //       indicatorSize: TabBarIndicatorSize.tab,
  //       labelColor: AppColor.textColor,
  //       unselectedLabelColor: AppColor.textColor.withValues(alpha: 0.5),
  //       labelStyle: const TextStyle(fontWeight: FontWeight.bold),
  //       dividerColor: Colors.transparent,
  //       tabs: [
  //         Tab(text: 'Daily'),
  //         Tab(text: 'Weekly'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFinancialSummary(List<User> users) {
    double totalSalary = users.fold(0, (sum, item) => sum + item.salary);
    double averageSalary = users.isEmpty ? 0 : totalSalary / users.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Estimated Payroll (Monthly)',
                style: TextStyle(color: AppColor.textColor, fontSize: 12),
              ),
              Icon(
                Icons.monetization_on_outlined,
                color: AppColor.textColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(totalSalary),
            style: const TextStyle(
              color: AppColor.textColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_outlined,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${users.length} Active Staff',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Avg: ${_formatCurrency(averageSalary)}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<User> users) {
    final totalEmployees = users.length;
    final adminCount = users
        .where((user) => user.role == UserRole.admin)
        .length;
    final supervisorCount = users
        .where((user) => user.role == UserRole.supervisor)
        .length;
    final hrdCount = users.where((user) => user.role == UserRole.hrd).length;
    final financeCount = users
        .where((user) => user.role == UserRole.finance)
        .length;
    final employeeCount = users
        .where((user) => user.role == UserRole.employee)
        .length;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _DashboardCard(
          title: 'Total Staff',
          value: totalEmployees.toString(),
          icon: Icons.groups_outlined,
          color: Colors.blueGrey,
          subtitle: 'All Departments',
        ),
        _DashboardCard(
          title: 'Admin',
          value: adminCount.toString(),
          icon: Icons.admin_panel_settings_outlined,
          color: UserColor.getColorByRole(UserRole.admin),
          subtitle: 'System Access',
        ),
        _DashboardCard(
          title: 'HRD',
          value: hrdCount.toString(),
          icon: Icons.assignment_ind_outlined,
          color: UserColor.getColorByRole(UserRole.hrd),
          subtitle: 'Human Resource',
        ),
        _DashboardCard(
          title: 'Supervisor',
          value: supervisorCount.toString(),
          icon: Icons.supervisor_account_outlined,
          color: UserColor.getColorByRole(UserRole.supervisor),
          subtitle: 'Team Leads',
        ),
        _DashboardCard(
          title: 'Finance',
          value: financeCount.toString(),
          icon: Icons.account_balance_wallet_outlined,
          color: UserColor.getColorByRole(UserRole.finance),
          subtitle: 'Accounting',
        ),
        _DashboardCard(
          title: 'Employees',
          value: employeeCount.toString(),
          icon: Icons.badge_outlined,
          color: UserColor.getColorByRole(UserRole.employee),
          subtitle: 'Staff Members',
        ),
      ],
    );
  }

  Widget _buildUserListPreview(List<User> users, ThemeData theme) {
    final recentUsers = users.take(5).toList();
    if (recentUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No data available'),
      );
    }
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: recentUsers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final u = recentUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: UserColor.getColorByRole(u.role),
              child: Text(
                u.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColor.textSecColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              u.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(u.role.name, style: const TextStyle(fontSize: 12)),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 34),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
