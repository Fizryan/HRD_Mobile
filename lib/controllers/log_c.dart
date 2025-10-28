import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/log_data.dart';
import 'package:hrd_system_project/models/log_m.dart';

class LogController extends ChangeNotifier {
  List<LogEntry> _logEntries = [];
  List<LogEntry> get logEntries => _logEntries;

  LogController() {
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    _logEntries = await LogData.loadLogs();
    notifyListeners();
  }

  Future<void> addLog(String actor, LogAction action, String details) async {
    final newLog = LogEntry(
      timestamp: DateTime.now(),
      actor: actor,
      action: action,
      details: details,
    );
    await LogData.addLog(newLog);
    await _loadLogs();
  }

  Future<void> clearLogs() async {
    await LogData.clearLogs();
    await _loadLogs();
  }
}
