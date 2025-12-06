import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:hrd_system_project/views/general_v.dart';
import 'package:provider/provider.dart';

class PayrollPanel extends StatefulWidget {
  final User user;
  const PayrollPanel({super.key, required this.user});

  @override
  State<PayrollPanel> createState() => _PayrollPanelState();
}

class _PayrollPanelState extends State<PayrollPanel> {
  String _selectedMonth = 'November 2024';
  String _selectedDepartment = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final allUsers = userProvider.users;
        final filteredUsers = _selectedDepartment == 'All'
            ? allUsers
            : allUsers
                  .where(
                    (u) => u.role.name == _selectedDepartment.toLowerCase(),
                  )
                  .toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildMonthSelector(),
                const SizedBox(height: 20),
                _buildPayrollSummary(filteredUsers),
                const SizedBox(height: 20),
                _buildDepartmentFilter(allUsers),
                const SizedBox(height: 20),
                _buildSectionTitle('Employee Payroll Details'),
                const SizedBox(height: 12),
                _buildPayrollList(filteredUsers),
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
        borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.payments,
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
                  'Payroll Management',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage employee salary and payments',
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

  Widget _buildMonthSelector() {
    final months = [
      'January 2024',
      'February 2024',
      'March 2024',
      'April 2024',
      'May 2024',
      'June 2024',
      'July 2024',
      'August 2024',
      'September 2024',
      'October 2024',
      'November 2024',
      'December 2024',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
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
      child: DropdownButton<String>(
        value: _selectedMonth,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.calendar_today, color: AppColor.grey600),
        style: const TextStyle(
          fontSize: 14,
          color: AppColor.textColor,
          fontWeight: FontWeight.bold,
        ),
        items: months.map((month) {
          return DropdownMenuItem(value: month, child: Text(month));
        }).toList(),
        onChanged: (value) => setState(() => _selectedMonth = value!),
      ),
    );
  }

  Widget _buildPayrollSummary(List<User> users) {
    final totalSalary = users.fold<double>(0, (sum, u) => sum + u.salary);
    final double avgSalary = users.isNotEmpty ? totalSalary / users.length : 0;
    final taxAmount = totalSalary * 0.05;
    final netPayroll = totalSalary - taxAmount;

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
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Payroll Summary',
            style: TextStyle(
              color: AppColor.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Utils.formatCurrency(totalSalary),
            style: const TextStyle(
              color: AppColor.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${users.length} Employees',
              style: const TextStyle(
                color: AppColor.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColor.white, thickness: 0.3),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Avg Salary',
                  Utils.formatCurrency(avgSalary),
                  Icons.trending_up,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColor.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Tax (5%)',
                  Utils.formatCurrency(taxAmount),
                  Icons.receipt,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColor.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Net Payroll',
                  Utils.formatCurrency(netPayroll),
                  Icons.account_balance,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColor.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColor.white, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDepartmentFilter(List<User> allUsers) {
    final departments = ['All'];
    final roles = allUsers.map((u) => u.role.name).toSet().toList();
    for (var role in roles) {
      departments.add(role[0].toUpperCase() + role.substring(1));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey200),
      ),
      child: DropdownButton<String>(
        value: _selectedDepartment,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.filter_list, color: AppColor.grey600),
        hint: const Text('Filter by Department'),
        style: const TextStyle(
          fontSize: 14,
          color: AppColor.textColor,
          fontWeight: FontWeight.w500,
        ),
        items: departments.map((dept) {
          return DropdownMenuItem(value: dept, child: Text(dept));
        }).toList(),
        onChanged: (value) => setState(() => _selectedDepartment = value!),
      ),
    );
  }

  Widget _buildPayrollList(List<User> users) {
    if (users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.black87.withValues(alpha: 0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColor.grey400),
            SizedBox(height: 16),
            Text(
              'No employees found',
              style: TextStyle(
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
        borderRadius: BorderRadius.circular(12),
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
          return _buildPayrollItem(user);
        },
      ),
    );
  }

  Widget _buildPayrollItem(User user) {
    final taxAmount = user.salary * 0.05;
    final netSalary = user.salary - taxAmount;

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: UserColor.getColorByRole(user.role).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            user.name[0].toUpperCase(),
            style: TextStyle(
              color: UserColor.getColorByRole(user.role),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: UserColor.getColorByRole(
                  user.role,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                user.role.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: UserColor.getColorByRole(user.role),
                ),
              ),
            ),
          ],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Utils.formatCurrency(user.salary),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: UserColor.getColorByRole(user.role),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Gross',
            style: TextStyle(fontSize: 10, color: AppColor.grey600),
          ),
        ],
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.grey100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              _buildPayrollDetailRow(
                'Gross Salary',
                Utils.formatCurrency(user.salary),
                AppColor.textColor,
              ),
              const SizedBox(height: 8),
              _buildPayrollDetailRow(
                'Tax (5%)',
                '- ${Utils.formatCurrency(taxAmount)}',
                AppColor.red,
              ),
              const Divider(height: 20),
              _buildPayrollDetailRow(
                'Net Salary',
                Utils.formatCurrency(netSalary),
                AppColor.green,
                isBold: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payslip generated for ${user.name}'),
                            backgroundColor: AppColor.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.description, size: 18),
                      label: const Text('Generate Payslip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UserColor.getColorByRole(
                          widget.user.role,
                        ),
                        foregroundColor: AppColor.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment processed for ${user.name}'),
                            backgroundColor: AppColor.blue,
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Process Payment'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: UserColor.getColorByRole(
                          widget.user.role,
                        ),
                        side: BorderSide(
                          color: UserColor.getColorByRole(widget.user.role),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayrollDetailRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColor.grey700,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
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
}
