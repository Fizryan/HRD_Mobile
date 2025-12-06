import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:hrd_system_project/views/general_v.dart';
import 'package:provider/provider.dart';

class HrdPanel extends StatefulWidget {
  final User user;
  const HrdPanel({super.key, required this.user});

  @override
  State<HrdPanel> createState() => _HrdPanelState();
}

class _HrdPanelState extends State<HrdPanel> {
  String _selectedDepartment = 'All';
  String _searchQuery = '';
  late final TextEditingController _searchController;

  static const _borderRadius12 = BorderRadius.all(Radius.circular(12));
  static const _borderRadius8 = BorderRadius.all(Radius.circular(8));
  static const _borderRadius6 = BorderRadius.all(Radius.circular(6));

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> _filterUsers(List<User> users) {
    return users.where((user) {
      final departmentMatch =
          _selectedDepartment == 'All' ||
          user.role.name.toLowerCase() == _selectedDepartment.toLowerCase();
      final searchMatch =
          _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.username.toLowerCase().contains(_searchQuery.toLowerCase());
      return departmentMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final allUsers = userProvider.users;
        final filteredUsers = _filterUsers(allUsers);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStatisticsCards(allUsers),
                const SizedBox(height: 20),
                _buildDepartmentBreakdown(allUsers),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildDepartmentFilter(allUsers),
                const SizedBox(height: 20),
                _buildSectionTitle('Employee Directory'),
                const SizedBox(height: 12),
                _buildEmployeeList(filteredUsers),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UserColor.getColorByRole(widget.user.role),
            UserColor.getColorByRole(widget.user.role).withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: _borderRadius12,
        boxShadow: [
          BoxShadow(
            color: UserColor.getColorByRole(
              widget.user.role,
            ).withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: _borderRadius8,
            ),
            child: Icon(
              Icons.people,
              color: UserColor.getColorByRole(widget.user.role),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Human Resource',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage employees and workforce',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 12,
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

  Widget _buildStatisticsCards(List<User> users) {
    final totalEmployees = users.length;
    final totalSalary = users.fold<double>(0, (sum, u) => sum + u.salary);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Employees',
            totalEmployees.toString(),
            Icons.people_outline,
            StatusColor.infoColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Payroll',
            Utils.formatCurrency(totalSalary),
            Icons.account_balance_wallet,
            StatusColor.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentBreakdown(List<User> users) {
    final departments = <String, int>{};
    for (var user in users) {
      final dept = user.role.name;
      departments[dept] = (departments[dept] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: UserColor.getColorByRole(
                    widget.user.role,
                  ).withValues(alpha: 0.1),
                  borderRadius: _borderRadius8,
                ),
                child: Icon(
                  Icons.pie_chart,
                  color: UserColor.getColorByRole(widget.user.role),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Department Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (departments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No departments found',
                  style: TextStyle(color: AppColor.grey600),
                ),
              ),
            )
          else
            ...departments.entries.map((entry) {
              final roleName =
                  entry.key[0].toUpperCase() + entry.key.substring(1);
              final roleEnum = UserRole.values.firstWhere(
                (r) => r.name == entry.key,
                orElse: () => UserRole.unknown,
              );
              final color = UserColor.getColorByRole(roleEnum);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: _borderRadius8,
                      ),
                      child: Center(
                        child: Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roleName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${((entry.value / users.length) * 100).toStringAsFixed(1)}% of workforce',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColor.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: _borderRadius6,
                      ),
                      child: Text(
                        '${entry.value} emp',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        border: Border.all(color: AppColor.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search employees...',
          hintStyle: TextStyle(color: AppColor.grey600, fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: AppColor.grey600),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColor.grey600, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDepartmentFilter(List<User> users) {
    final departments = ['All'];
    final roles = users.map((u) => u.role.name).toSet().toList();
    for (var role in roles) {
      departments.add(role[0].toUpperCase() + role.substring(1));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        border: Border.all(color: AppColor.grey200),
      ),
      child: DropdownButtonFormField2<String>(
        value: _selectedDepartment,
        isExpanded: true,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.filter_list, color: AppColor.grey600),
        ),
        hint: const Text('Filter by Department'),
        style: const TextStyle(
          fontSize: 14,
          color: AppColor.textColor,
          fontWeight: FontWeight.w500,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        items: departments.map((dept) {
          return DropdownMenuItem(value: dept, child: Text(dept));
        }).toList(),
        onChanged: (value) => setState(() => _selectedDepartment = value!),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: UserColor.getColorByRole(widget.user.role),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeList(List<User> users) {
    if (users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: _borderRadius12,
          boxShadow: [
            BoxShadow(
              color: AppColor.black87.withValues(alpha: 0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColor.grey400),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No employees match your search'
                  : 'No employees found',
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildEmployeeItem(user);
        },
      ),
    );
  }

  Widget _buildEmployeeItem(User user) {
    final roleColor = UserColor.getColorByRole(user.role);

    return InkWell(
      onTap: () => _showEmployeeDetails(context, user),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  user.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 12,
                        color: AppColor.grey600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColor.grey600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.1),
                          borderRadius: _borderRadius6,
                        ),
                        child: Text(
                          user.role.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: roleColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Utils.formatCurrency(user.salary),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'per month',
                  style: const TextStyle(fontSize: 10, color: AppColor.grey600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, User user) {
    final roleColor = UserColor.getColorByRole(user.role);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [roleColor, roleColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black87.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: roleColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Employee Profile',
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: AppColor.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: AppColor.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Username',
                      user.username,
                      Icons.account_circle,
                      roleColor,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Department',
                      user.role.name[0].toUpperCase() +
                          user.role.name.substring(1),
                      Icons.business,
                      roleColor,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Monthly Salary',
                      Utils.formatCurrency(user.salary),
                      Icons.payments,
                      roleColor,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Annual Salary',
                      Utils.formatCurrency(user.salary * 12),
                      Icons.account_balance_wallet,
                      roleColor,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColor.grey100,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roleColor,
                      foregroundColor: AppColor.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        border: Border.all(color: AppColor.grey200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
