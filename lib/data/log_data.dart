import 'dart:convert';
import 'package:hrd_system_project/models/log_m.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogData {
  static const String _keyLogs = 'logs';

  static Future<void> saveLogs(List<LogEntry> logs) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> logJsonList = logs.map((log) => jsonEncode(log.toJson())).toList();
    await prefs.setStringList(_keyLogs, logJsonList);
  }

  static Future<List<LogEntry>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logJsonList = prefs.getStringList(_keyLogs);

    if (logJsonList == null) return [];

    return logJsonList.map((jsonStr) {
      final logMap = jsonDecode(jsonStr);
      return LogEntry.fromJson(logMap);
    }).toList();
  }

  static Future<void> addLog(LogEntry log) async {
    final logs = await loadLogs();
    logs.insert(0, log);
    await saveLogs(logs);
  }

  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogs);
  }
}
