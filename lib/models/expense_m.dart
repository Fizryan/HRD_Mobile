import 'package:hive/hive.dart';

// #region expense
part '../generated/expense_m.g.dart';

@HiveType(typeId: 2)
enum ExpenseStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
}

@HiveType(typeId: 3)
enum ExpenseCategory {
  @HiveField(0)
  operational,
  @HiveField(1)
  marketing,
  @HiveField(2)
  technology,
  @HiveField(3)
  employeeWelfare,
}

@HiveType(typeId: 4)
class Expense {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final ExpenseCategory category;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  ExpenseStatus status;
  @HiveField(6)
  final String requestedByUsername; // reference to User.username

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.status,
    required this.requestedByUsername,
  });

  String get categoryName {
    switch (category) {
      case ExpenseCategory.operational:
        return 'Operational';
      case ExpenseCategory.marketing:
        return 'Marketing';
      case ExpenseCategory.technology:
        return 'Technology';
      case ExpenseCategory.employeeWelfare:
        return 'Welfare';
    }
  }

  String get statusName {
    switch (status) {
      case ExpenseStatus.pending:
        return 'Pending';
      case ExpenseStatus.approved:
        return 'Approved';
      case ExpenseStatus.rejected:
        return 'Rejected';
    }
  }
}

// #endregion
