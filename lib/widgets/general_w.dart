import 'package:flutter/material.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';
import 'package:hrd_system_project/models/status_m.dart';

class GeneralWidget {
  Widget buildStatsHeader(List<Widget> widgetsChildrens, User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorUser().getColor(user.role), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgetsChildrens,
        ),
      ),
    );
  }

  Widget buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
        ),
      ],
    );
  }

  Widget buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSystemInfo(List<Widget> widgetsChildrens) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'System Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: widgetsChildrens,
            ),
          ],
        ),
      ),
    );
  }

  List<Card> toDoInfoChildrens(
    String titleText,
    String subtitleText,
    int randomInt,
    Icon iconUser,
    User user,
    TabController tabController,
    Icon iconList,
  ) => <Card>[
    Card(
      elevation: 4,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        leading: iconList,
        title: Text(titleText, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$randomInt, $subtitleText"),
        trailing: iconUser,
        onTap: () {
          if (titleText == "Leave Request" && user.role == UserRole.hrd) {
            tabController.animateTo(1);
          }
          if (titleText == "Reimbursement Request" &&
              user.role == UserRole.finance) {
            tabController.animateTo(2);
          }
          if (titleText == "Finance Table" && user.role == UserRole.finance) {
            tabController.animateTo(1);
          }
        },
      ),
    ),
  ];

  Widget buildApprovalCard(
    User user,
    ApprovalRequest approvalRequest,
    Function onApprove,
    Function onDeny,
  ) {
    final ApprovalStatusState statusHelper = ApprovalStatusState();
    String formattedAmount = 'N/A';
    if (approvalRequest.amount != null && approvalRequest.amount! > 0) {
      formattedAmount = 'Rp ${approvalRequest.amount!.toStringAsFixed(0)}';
    }

    String subtitleLine1 =
        (approvalRequest.type == RequestType.claimReimbursment)
        ? '${approvalRequest.type.displayName} - $formattedAmount'
        : '${approvalRequest.type.displayName} - ${approvalRequest.days} days';

    String date = approvalRequest.date;
    String reason = approvalRequest.reason;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorUser().getColor(user.role), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        leading: CircleAvatar(
          backgroundColor: statusHelper.getApprovalStatusColor(
            approvalRequest.status,
          ),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
        title: Text(
          approvalRequest.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitleLine1,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              reason,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => onDeny(),
              tooltip: 'Reject',
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => onApprove(),
              tooltip: 'Approve',
            ),
          ],
        ),
      ),
    );
  }
}
