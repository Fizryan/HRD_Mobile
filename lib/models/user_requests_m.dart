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
  ApprovalStatus status = ApprovalStatus.pending;

  ApprovalRequest({
    required this.id,
    required this.name,
    required this.role,
    required this.type,
    required this.date,
    required this.days,
    this.amount,
    required this.reason,
  });
}
