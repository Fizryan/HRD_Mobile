enum LogAction {
  createUser,
  updateUser,
  deleteUser,
  clearData,
  approveRequest,
  denyRequest,
}

class LogEntry {
  final DateTime timestamp;
  final String actor;
  final LogAction action;
  final String details;

  LogEntry({
    required this.timestamp,
    required this.actor,
    required this.action,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'actor': actor,
    'action': action.toString(),
    'details': details,
  };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
    timestamp: DateTime.parse(json['timestamp']),
    actor: json['actor'],
    action: LogAction.values.firstWhere((e) => e.toString() == json['action']),
    details: json['details'],
  );
}
