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

class _AdminPanelState extends State<AdminPanel> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
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

  // #region header
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UserColor.getColorByRole(widget.user.role),
            UserColor.getColorByRole(widget.user.role).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: UserColor.getColorByRole(
              widget.user.role,
            ).withValues(alpha: 0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.waving_hand,
                            color: AppColor.white,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.user.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 26,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColor.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.admin_panel_settings_rounded,
                            color: AppColor.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.user.role.name.toUpperCase(),
                            style: const TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: AppColor.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColor.white,
                  child: Icon(
                    Icons.person,
                    color: UserColor.getColorByRole(widget.user.role),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // #endregion

  // #region financial summary
  Widget _buildFinancialSummary(List<User> users) {
    double totalSalary = users.fold(0, (sum, item) => sum + item.salary);
    double averageSalary = users.isEmpty ? 0 : totalSalary / users.length;
    double budgetTarget = 100000000;
    double budgetPercentage = (totalSalary / budgetTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.buttonPrimary, AppColor.buttonPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blue.withValues(alpha: 0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: AppColor.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Estimated Payroll (Monthly)',
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _formatCurrency(totalSalary),
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColor.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: AppColor.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(budgetPercentage * 100).toStringAsFixed(1)}% of budget',
                            style: const TextStyle(
                              color: AppColor.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: budgetPercentage,
                    minHeight: 8,
                    backgroundColor: AppColor.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildPayrollStat(
                        icon: Icons.people,
                        label: 'Active Staff',
                        value: '${users.length}',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColor.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _buildPayrollStat(
                        icon: Icons.payments_outlined,
                        label: 'Avg Salary',
                        value: _formatCurrency(averageSalary),
                        isCompact: true,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColor.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _buildPayrollStat(
                        icon: Icons.calendar_today,
                        label: 'This Month',
                        value: DateTime.now().month.toString().padLeft(2, '0'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollStat({
    required IconData icon,
    required String label,
    required String value,
    bool isCompact = false,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColor.white.withValues(alpha: 0.9), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: AppColor.white,
            fontSize: isCompact ? 11 : 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColor.white.withValues(alpha: 0.8),
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  // #endregion

  // #region stats
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
      childAspectRatio: 1.2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _DashboardCard(
          title: 'Total Staff',
          value: totalEmployees.toString(),
          icon: Icons.groups_outlined,
          color: AppColor.blueGrey,
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
  // #endregion

  // #region userlist preview
  Widget _buildUserListPreview(List<User> users, ThemeData theme) {
    final recentUsers = users.take(5).toList();
    if (recentUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.grey100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 48, color: AppColor.grey600),
            const SizedBox(height: 8),
            const Text(
              'No data available',
              style: TextStyle(
                color: AppColor.grey600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Card(
      elevation: 2,
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: recentUsers.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, thickness: 0.5, color: AppColor.grey200),
        ),
        itemBuilder: (context, index) {
          final u = recentUsers[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: UserColor.getColorByRole(u.role),
                    child: Text(
                      u.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.white, width: 1.5),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColor.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                u.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: UserColor.getColorByRole(
                          u.role,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        u.role.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: UserColor.getColorByRole(u.role),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star, size: 14, color: AppColor.grey600),
                    const SizedBox(width: 2),
                    Text(
                      _formatCurrency(u.salary),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // #endregion
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
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    if (subtitle != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 9,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColor.grey600,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppColor.grey600,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
