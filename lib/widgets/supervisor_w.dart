import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/data/user_requests_data.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/models/user_requests_m.dart';
import 'package:hrd_system_project/widgets/general_w.dart';

class SupervisorPanel extends StatefulWidget {
  final User user;
  const SupervisorPanel({super.key, required this.user});
  @override
  State<SupervisorPanel> createState() => _SupervisorPanelState();
}

class _SupervisorPanelState extends State<SupervisorPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApprovalStatusState _statusHelper = ApprovalStatusState();
  final InfoStatusState _infoStatusHelper = InfoStatusState();

  late Future<List<ApprovalRequest>> _pendingRequestsFuture;
  List<ApprovalRequest> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    req.role == UserRole.employee &&
                    req.status == ApprovalStatus.pending,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: GeneralWidget().buildStatsHeader(
            headerChildrens(context),
            widget.user,
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
            children: [_buildSummaryTab(), _buildApprovalList()],
          ),
        ),
      ],
    );
  }
  // #endregion

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            ...GeneralWidget().toDoInfoChildrens(
              'Persetujuan Cuti & Dinas',
              'Pengajuan baru menunggu persetujuan Anda.',
              _pendingRequests.length,
              Icon(Icons.chevron_right),
              widget.user,
              _tabController,
            ),
            const SizedBox(height: 24),
            Text(
              "Kinerja Tim Anda",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._superVisorChartChildrens(),
            const SizedBox(height: 24),
            _buildTeamMemberProgress(
              name: "Bunga (UI/UX)",
              progress: CurrentRandom.getDoubleRandom(0, 1),
              color: Colors.green,
            ),
            _buildTeamMemberProgress(
              name: "Andi (Programmer)",
              progress: CurrentRandom.getDoubleRandom(0, 1),
              color: Colors.blue,
            ),
            _buildTeamMemberProgress(
              name: "Cecep (QA)",
              progress: CurrentRandom.getDoubleRandom(0, 1),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  // #region header
  List<Widget> headerChildrens(BuildContext context) => <Widget>[
    Expanded(
      child: GeneralWidget().buildStatItem(
        context,
        'Employee',
        CurrentRandom.getIntRandom(4, 12).toString(),
        Icons.people,
        Colors.blue,
      ),
    ),
    Expanded(
      child: GeneralWidget().buildStatItem(
        context,
        'Pending Request',
        _pendingRequests.length.toString(),
        Icons.pending,
        Colors.orange,
      ),
    ),
  ];
  // #endregion

  // #region chart
  List<SizedBox> _superVisorChartChildrens() => <SizedBox>[
    SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              title: '40%',
              color: Colors.blue,
              radius: 50,
            ),
            PieChartSectionData(
              value: 30,
              title: '30%',
              color: Colors.green,
              radius: 50,
            ),
            PieChartSectionData(
              value: 20,
              title: '20%',
              color: Colors.orange,
              radius: 50,
            ),
            PieChartSectionData(
              value: 10,
              title: '10%',
              color: Colors.red,
              radius: 50,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    ),
  ];
  // #endregion

  // #region team member progress
  Widget _buildTeamMemberProgress({
    required String name,
    required double progress,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text("${(progress * 100).toInt()}%"),
            ),
          ],
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
        'Pengajuan dari ${request.name} telah di ${status.name} oleh supervisor.';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _infoStatusHelper.getInfoStatusIcon(status),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _infoStatusHelper.getInfoStatusColor(status),
      ),
    );
  }

  // #endregion
}
