import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/expense_m.dart';
import 'package:hrd_system_project/controllers/expense_c.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:hrd_system_project/views/general_v.dart';
import 'package:provider/provider.dart';

class ExpensePanel extends StatefulWidget {
  final User user;
  const ExpensePanel({super.key, required this.user});

  @override
  State<ExpensePanel> createState() => _ExpensePanelState();
}

class _ExpensePanelState extends State<ExpensePanel> {
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  static const _borderRadius12 = BorderRadius.all(Radius.circular(12));
  static const _borderRadius8 = BorderRadius.all(Radius.circular(8));
  static const _borderRadius6 = BorderRadius.all(Radius.circular(6));

  List<Expense> _filterExpenses(List<Expense> expenses) {
    return expenses.where((expense) {
      final categoryMatch =
          _selectedCategory == 'All' ||
          expense.categoryName == _selectedCategory;
      final statusMatch =
          _selectedStatus == 'All' || expense.statusName == _selectedStatus;
      return categoryMatch && statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExpenseProvider, UserProvider>(
      builder: (context, expenseProvider, userProvider, child) {
        final allExpenses = expenseProvider.expenses;
        final filteredExpenses = _filterExpenses(allExpenses);
        final users = userProvider.users;

        final totalExpenses = filteredExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
        final approvedExpenses = filteredExpenses
            .where((e) => e.status == ExpenseStatus.approved)
            .fold<double>(0, (sum, e) => sum + e.amount);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSummaryCards(totalExpenses, approvedExpenses),
                const SizedBox(height: 20),
                _buildFilters(),
                const SizedBox(height: 20),
                _buildSectionTitle('Expense List'),
                const SizedBox(height: 12),
                _buildExpenseList(filteredExpenses, users),
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
              Icons.receipt_long,
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
                  'Expense Management',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track and manage company expenses',
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

  Widget _buildSummaryCards(double total, double approved) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Expenses',
            Utils.formatCurrency(total),
            Icons.account_balance_wallet,
            StatusColor.infoColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Approved',
            Utils.formatCurrency(approved),
            Icons.check_circle,
            StatusColor.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
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
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            'Category',
            _selectedCategory,
            [
              'All',
              'Operational',
              'Marketing',
              'Technology',
              'Employee Welfare',
            ],
            (value) => setState(() => _selectedCategory = value!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFilterDropdown(
            'Status',
            _selectedStatus,
            ['All', 'Pending', 'Approved', 'Rejected'],
            (value) => setState(() => _selectedStatus = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _borderRadius12,
        border: Border.all(color: AppColor.grey200),
      ),
      child: DropdownButtonFormField2<String>(
        value: value,
        isExpanded: true,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
        ),
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
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildExpenseList(List<Expense> expenses, List<User> users) {
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
      child: expenses.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 64, color: AppColor.grey400),
                  const SizedBox(height: 16),
                  const Text(
                    'No expenses found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final user = users.firstWhere(
                  (u) => u.username == expense.requestedByUsername,
                  orElse: () => User(
                    username: 'unknown',
                    password: '',
                    name: 'Unknown User',
                    role: UserRole.unknown,
                  ),
                );
                return RepaintBoundary(
                  key: ValueKey(expense.id),
                  child: _buildExpenseItem(expense, user),
                );
              },
            ),
    );
  }

  Widget _buildExpenseItem(Expense expense, User requestedBy) {
    Color statusColor;
    IconData statusIcon;
    switch (expense.status) {
      case ExpenseStatus.approved:
        statusColor = StatusColor.successColor;
        statusIcon = Icons.check_circle;
        break;
      case ExpenseStatus.pending:
        statusColor = StatusColor.warningColor;
        statusIcon = Icons.schedule;
        break;
      case ExpenseStatus.rejected:
        statusColor = StatusColor.errorColor;
        statusIcon = Icons.cancel;
        break;
    }

    return InkWell(
      onTap: () => _showExpenseActionDialog(context, expense),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.grey200,
                      borderRadius: _borderRadius6,
                    ),
                    child: Text(
                      expense.categoryName,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColor.grey700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    expense.id,
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColor.grey600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: UserColor.getColorByRole(
                        requestedBy.role,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        requestedBy.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: UserColor.getColorByRole(requestedBy.role),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    requestedBy.name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColor.grey600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: UserColor.getColorByRole(
                        requestedBy.role,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      requestedBy.role.name,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: UserColor.getColorByRole(requestedBy.role),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColor.grey600,
                  ),
                  Text(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColor.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Utils.formatCurrency(expense.amount),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: _borderRadius6,
              ),
              child: Text(
                expense.statusName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
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

  void _showExpenseActionDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (dialogContext) => Consumer2<ExpenseProvider, UserProvider>(
        builder: (context, expenseProvider, userProvider, _) {
          final requestedBy = userProvider.users.firstWhere(
            (u) => u.username == expense.requestedByUsername,
            orElse: () => User(
              username: 'unknown',
              password: '',
              name: 'Unknown User',
              role: UserRole.unknown,
            ),
          );
          final statusColor = _getStatusColor(expense.status);
          final statusIcon = _getStatusIcon(expense.status);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor,
                          statusColor.withValues(alpha: 0.8),
                        ],
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.black87.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: statusColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense Details',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      statusIcon,
                                      size: 12,
                                      color: AppColor.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      expense.statusName,
                                      style: const TextStyle(
                                        color: AppColor.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & ID
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                expense.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${expense.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.grey600,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Amount Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                statusColor.withValues(alpha: 0.1),
                                statusColor.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 20,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Utils.formatCurrency(expense.amount),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Info Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                'Category',
                                expense.categoryName,
                                Icons.category_outlined,
                                AppColor.grey700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                'Date',
                                '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                                Icons.calendar_today,
                                AppColor.grey700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Requester Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: UserColor.getColorByRole(
                              requestedBy.role,
                            ).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: UserColor.getColorByRole(
                                requestedBy.role,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: UserColor.getColorByRole(
                                    requestedBy.role,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    requestedBy.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: UserColor.getColorByRole(
                                        requestedBy.role,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Requested By',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColor.grey600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      requestedBy.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textColor,
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
                                  color: UserColor.getColorByRole(
                                    requestedBy.role,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  requestedBy.role.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: UserColor.getColorByRole(
                                      requestedBy.role,
                                    ),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  if (expense.status == ExpenseStatus.pending)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.grey100,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _rejectExpense(expense, expenseProvider);
                              },
                              icon: const Icon(Icons.cancel, size: 20),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: StatusColor.errorColor,
                                side: BorderSide(
                                  color: StatusColor.errorColor,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _approveExpense(expense, expenseProvider);
                              },
                              icon: const Icon(Icons.check_circle, size: 20),
                              label: const Text('Approve Expense'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: StatusColor.successColor,
                                foregroundColor: AppColor.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.grey600,
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
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return StatusColor.successColor;
      case ExpenseStatus.pending:
        return StatusColor.warningColor;
      case ExpenseStatus.rejected:
        return StatusColor.errorColor;
    }
  }

  IconData _getStatusIcon(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.approved:
        return Icons.check_circle;
      case ExpenseStatus.pending:
        return Icons.schedule;
      case ExpenseStatus.rejected:
        return Icons.cancel;
    }
  }

  Future<void> _approveExpense(
    Expense expense,
    ExpenseProvider expenseProvider,
  ) async {
    final updatedExpense = Expense(
      id: expense.id,
      title: expense.title,
      category: expense.category,
      amount: expense.amount,
      date: expense.date,
      status: ExpenseStatus.approved,
      requestedByUsername: expense.requestedByUsername,
    );

    await expenseProvider.updateExpense(updatedExpense);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColor.white),
            const SizedBox(width: 8),
            Text('${expense.title} approved'),
          ],
        ),
        backgroundColor: StatusColor.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _rejectExpense(
    Expense expense,
    ExpenseProvider expenseProvider,
  ) async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: StatusColor.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cancel,
                color: StatusColor.errorColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirm Rejection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: AppColor.textColor),
            children: [
              const TextSpan(text: 'Are you sure you want to reject '),
              TextSpan(
                text: expense.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: StatusColor.errorColor,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColor.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: StatusColor.errorColor,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reject',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final updatedExpense = Expense(
        id: expense.id,
        title: expense.title,
        category: expense.category,
        amount: expense.amount,
        date: expense.date,
        status: ExpenseStatus.rejected,
        requestedByUsername: expense.requestedByUsername,
      );

      await expenseProvider.updateExpense(updatedExpense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cancel, color: AppColor.white),
              const SizedBox(width: 8),
              Text('${expense.title} rejected'),
            ],
          ),
          backgroundColor: StatusColor.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
