import 'package:flutter/material.dart';

enum LoginStatus { initial, loading, success, failed }

enum ApprovalStatus { approved, denied, pending }

class ApprovalStatusState {
  Color getApprovalStatusColor(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.approved:
        return Colors.green;
      case ApprovalStatus.denied:
        return Colors.red;
      case ApprovalStatus.pending:
        return Colors.orange;
    }
  }

  Icon getApprovalStatusIcon(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ApprovalStatus.denied:
        return const Icon(Icons.cancel, color: Colors.red);
      case ApprovalStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
    }
  }
}

enum InfoStatus { created, updated, deleted, warning, error, info }

class InfoStatusState {
  Color getInfoStatusColor(InfoStatus status) {
    switch (status) {
      case InfoStatus.created:
        return Colors.green;
      case InfoStatus.updated:
        return Colors.blue;
      case InfoStatus.deleted:
        return Colors.red;
      case InfoStatus.warning:
        return Colors.orange;
      case InfoStatus.error:
        return Colors.red;
      case InfoStatus.info:
        return Colors.grey;
    }
  }

  Icon getInfoStatusIcon(InfoStatus status) {
    switch (status) {
      case InfoStatus.created:
        return const Icon(Icons.check, color: Colors.green);
      case InfoStatus.updated:
        return const Icon(Icons.update, color: Colors.blue);
      case InfoStatus.deleted:
        return const Icon(Icons.delete, color: Colors.red);
      case InfoStatus.warning:
        return const Icon(Icons.warning, color: Colors.orange);
      case InfoStatus.error:
        return const Icon(Icons.error, color: Colors.red);
      case InfoStatus.info:
        return const Icon(Icons.info, color: Colors.grey);
    }
  }
}
