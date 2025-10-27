import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/hrd_c.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/data/user_requests_data.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';
import 'package:provider/provider.dart';

class FinancePanel extends StatefulWidget {
  final User user;
  const FinancePanel({super.key, required this.user});

  @override
  State<FinancePanel> createState() => _FinancePanelState();
}

class _FinancePanelState extends State<FinancePanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ApprovalStatusState _statusHelper = ApprovalStatusState();
  final InfoStatusState _infoStatusHelper = InfoStatusState();

  late Future<List<ApprovalRequest>> _pendingRequestsFuture;
  List<ApprovalRequest> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPendingRequests();
  }

  void _loadPendingRequests() {
    _pendingRequestsFuture = UserRequestsData.getPendingRequests().then((
      requests,
    ) {
      if (mounted) {
        setState(() {
          _pendingRequests = requests
              .where(
                (req) =>
                    (req.role == UserRole.employee ||
                        req.role == UserRole.supervisor ||
                        req.role == UserRole.finance ||
                        req.role == UserRole.admin) &&
                    req.type == RequestType.claimReimbursment,
              )
              .toList();
        });
      }
      return _pendingRequests;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = CurrentDate.getDate();
    final hrdController = context.watch<HrdController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "Berikut ringkasan aktivitas hari ini",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TabBar(
          controller: _tabController,
          labelColor: ColorUser().getColor(widget.user.role),
          indicatorColor: ColorUser().getColor(widget.user.role),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Approval'),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSummaryManagement(hrdController.employeeList, currentDate),
              _buildApprovalList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryManagement(List<User> users, String currentDate) {
    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                return ColorUser().getColor(widget.user.role);
              }),
              columns: const [
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Row(children: [Text(user.name)])),
                    DataCell(Text(currentDate)),
                    DataCell(Text('Rp.${user.salary.toStringAsFixed(0)}')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalList() {
    return FutureBuilder<List<ApprovalRequest>>(
      future: _pendingRequestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (_pendingRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statusHelper.getApprovalStatusIcon(ApprovalStatus.approved),
                const SizedBox(height: 16),
                const Text(
                  'Tidak ada pengajuan pending',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: _pendingRequests.length,
          itemBuilder: (context, index) {
            final request = _pendingRequests[index];
            return _buildApprovalCard(request);
          },
        );
      },
    );
  }

  Widget _buildApprovalCard(ApprovalRequest approvalRequest) {
    String formattedAmount = 'N/A';
    if (approvalRequest.amount != null && approvalRequest.amount! > 0) {
      formattedAmount = 'Rp ${approvalRequest.amount!.toStringAsFixed(0)}';
    }

    String subtitleLine1 =
        (approvalRequest.type == RequestType.claimReimbursment)
        ? '${approvalRequest.type.displayName} - $formattedAmount'
        : '${approvalRequest.type.displayName} - ${approvalRequest.days} hari';

    String date = approvalRequest.date;
    String reason = approvalRequest.reason;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
        side: BorderSide(
          color: ColorUser().getColor(widget.user.role),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        leading: CircleAvatar(
          backgroundColor: _statusHelper.getApprovalStatusColor(
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
              onPressed: () {
                _handleApproval(approvalRequest, isApproved: false);
              },
              tooltip: 'Tolak',
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                _handleApproval(approvalRequest, isApproved: true);
              },
              tooltip: 'Setujui',
            ),
          ],
        ),
      ),
    );
  }

  void _handleApproval(
    ApprovalRequest request, {
    required bool isApproved,
  }) async {
    setState(() {
      request.status = isApproved
          ? ApprovalStatus.approved
          : ApprovalStatus.denied;
      _pendingRequests.remove(request);
    });

    await UserRequestsData.saveRequests(_pendingRequests);

    if (!mounted) return;
    final status = isApproved ? InfoStatus.created : InfoStatus.deleted;
    final message =
        'Pengajuan dari ${request.name} telah ${isApproved ? 'disetujui' : 'ditolak'}';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.approval_rounded,
              color: isApproved ? Colors.blue : Colors.amber,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: _infoStatusHelper.getInfoStatusColor(status),
      ),
    );
  }
}
