import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_data_c.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/data/user_requests_data.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';
import 'package:hrd_system_project/widgets/general_w.dart';
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
                    req.role != UserRole.unknown &&
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

  // #region build
  @override
  Widget build(BuildContext context) {
    String currentDate = CurrentDate.getDate();
    final hrdController = context.watch<UserController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "The following is a summary of today's activities",
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
            Tab(text: 'Table'),
            Tab(text: 'Approval'),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TabBarView(
            controller: _tabController,
            children: [
              _dashboardSummary(_tabController, hrdController),
              _buildSummaryManagement(hrdController.employeeList, currentDate),
              _buildApprovalList(),
            ],
          ),
        ),
      ],
    );
  }
  // #endregion

  // #region summary
  Widget _dashboardSummary(
    TabController tabController,
    UserController hrdController,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...GeneralWidget().toDoInfoChildrens(
              'Reimbursement Request',
              'New submissions are waiting for your approval.',
              _pendingRequests.length,
              Icon(Icons.chevron_right),
              widget.user,
              tabController,
              Icon(Icons.pending_actions, color: Colors.orange, size: 32),
            ),
            const SizedBox(height: 12),
            ...GeneralWidget().toDoInfoChildrens(
              'Finance Table',
              'Employee Salary List.',
              hrdController.employeeList.length,
              Icon(Icons.chevron_right),
              widget.user,
              tabController,
              Icon(Icons.table_chart_rounded, color: Colors.orange, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryManagement(List<User> users, String currentDate) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(16),
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
    );
  }
  // #endregion

  // #region approval list
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
                  'No pending submissions',
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
            return GeneralWidget().buildApprovalCard(
              widget.user,
              request,
              () {
                _handleApproval(request, isApproved: true);
              },
              () {
                _handleApproval(request, isApproved: false);
              },
            );
          },
        );
      },
    );
  }
  // #endregion

  // #region handle approval
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
        'Submission from ${request.name} has been ${isApproved ? 'approved' : 'rejected'}';
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

  // #endregion
}
