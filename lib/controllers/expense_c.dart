import 'package:hrd_system_project/models/expense_m.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

// #region expense service
class ExpenseService {
  static const String _expenseBoxName = 'expenses';
  static Box<Expense>? _expenseBox;

  static Future<Box<Expense>> _openBox() async {
    _expenseBox ??= await Hive.openBox<Expense>(_expenseBoxName);
    return _expenseBox!;
  }

  static Future<void> initialize() async {
    await _openBox();
  }

  static Future<void> addExpense(Expense expense) async {
    final box = await _openBox();
    await box.put(expense.id, expense);
  }

  static Future<void> addExpenseList(List<Expense> expenses) async {
    final box = await _openBox();
    for (final expense in expenses) {
      await box.put(expense.id, expense);
    }
  }

  static Future<List<Expense>> getAllExpenses() async {
    final box = await _openBox();
    return box.values.toList();
  }

  static Future<Expense?> getExpense(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  static Future<void> updateExpense(Expense expense) async {
    final box = await _openBox();
    await box.put(expense.id, expense);
  }

  static Future<void> deleteExpense(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  static Future<void> clearAllExpenses() async {
    final box = await _openBox();
    await box.clear();
  }

  static Future<void> seedExpenses(List<Expense> expenses) async {
    final box = await _openBox();
    if (box.isEmpty) {
      for (final expense in expenses) {
        await box.put(expense.id, expense);
      }
    }
  }
}

// #endregion

// #region expense provider
class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> initialize() async {
    await ExpenseService.initialize();
    await loadExpenses();
  }

  Future<void> loadExpenses() async {
    _expenses = await ExpenseService.getAllExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await ExpenseService.addExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> addExpenseList(List<Expense> expenses) async {
    await ExpenseService.addExpenseList(expenses);
    _expenses.addAll(expenses);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await ExpenseService.updateExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await ExpenseService.deleteExpense(id);
    await loadExpenses();
  }

  Future<void> clearAllExpenses() async {
    await ExpenseService.clearAllExpenses();
    await loadExpenses();
  }

  List<Expense> getExpensesByUsername(String username) {
    return _expenses.where((e) => e.requestedByUsername == username).toList();
  }

  List<Expense> getExpensesByCategory(ExpenseCategory category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> getExpensesByStatus(ExpenseStatus status) {
    return _expenses.where((e) => e.status == status).toList();
  }

  double getTotalExpensesByStatus(ExpenseStatus status) {
    return _expenses
        .where((e) => e.status == status)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }
}

// #endregion

// #region dummy expenses
final List<Expense> dummyExpenses = [
  Expense(
    id: 'EXP-001',
    title: 'Office Supplies',
    category: ExpenseCategory.operational,
    amount: 2500000,
    date: DateTime(2024, 11, 15),
    status: ExpenseStatus.approved,
    requestedByUsername: 'naufal', // Supervisor
  ),
  Expense(
    id: 'EXP-002',
    title: 'Team Building Event',
    category: ExpenseCategory.employeeWelfare,
    amount: 15000000,
    date: DateTime(2024, 11, 18),
    status: ExpenseStatus.pending,
    requestedByUsername: 'haidar', // HRD
  ),
  Expense(
    id: 'EXP-003',
    title: 'Software License',
    category: ExpenseCategory.technology,
    amount: 8500000,
    date: DateTime(2024, 11, 20),
    status: ExpenseStatus.approved,
    requestedByUsername: 'cecep', // Employee
  ),
  Expense(
    id: 'EXP-004',
    title: 'Marketing Campaign',
    category: ExpenseCategory.marketing,
    amount: 25000000,
    date: DateTime(2024, 11, 10),
    status: ExpenseStatus.rejected,
    requestedByUsername: 'naufal', // Supervisor
  ),
  Expense(
    id: 'EXP-005',
    title: 'Office Rent',
    category: ExpenseCategory.operational,
    amount: 35000000,
    date: DateTime(2024, 11, 1),
    status: ExpenseStatus.approved,
    requestedByUsername: 'fizryan', // Admin
  ),
  Expense(
    id: 'EXP-006',
    title: 'Employee Training Program',
    category: ExpenseCategory.employeeWelfare,
    amount: 12000000,
    date: DateTime(2024, 11, 5),
    status: ExpenseStatus.approved,
    requestedByUsername: 'haidar', // HRD
  ),
  Expense(
    id: 'EXP-007',
    title: 'Cloud Infrastructure',
    category: ExpenseCategory.technology,
    amount: 18000000,
    date: DateTime(2024, 11, 12),
    status: ExpenseStatus.pending,
    requestedByUsername: 'cecep', // Employee
  ),
];

// #endregion
