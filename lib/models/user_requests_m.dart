import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';

class ApprovalRequest {
  final int id;
  final String name;
  final UserRole role;
  final RequestType type;
  final String date;
  final int days;
  final double? amount;
  final String reason;
  ApprovalStatus status;

  ApprovalRequest({
    required this.id,
    required this.name,
    required this.role,
    required this.type,
    required this.date,
    required this.days,
    this.amount,
    required this.reason,
    this.status = ApprovalStatus.pending,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'type': type.name,
        'date': date,
        'days': days,
        'amount': amount,
        'reason': reason,
        'status': status.name,
      };

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) => ApprovalRequest(
        id: json['id'],
        name: json['name'],
        role: UserRole.values.firstWhere((e) => e.name == json['role']),
        type: RequestType.values.firstWhere((e) => e.name == json['type']),
        date: json['date'],
        days: json['days'],
        amount: json['amount'],
        reason: json['reason'],
        status:
            ApprovalStatus.values.firstWhere((e) => e.name == json['status']),
      );
}
