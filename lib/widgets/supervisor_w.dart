import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/models/user_m.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GeneralWidget().buildStatsHeader(headerChildrens, widget.user),
            const SizedBox(height: 24),
            ...GeneralWidget().toDoInfoChildrens(
              'Persetujuan Cuti & Dinas',
              'Pengajuan baru menunggu persetujuan Anda.',
              CurrentRandom.getIntRandom(0, 12),
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

  List<Widget> get headerChildrens => <Widget>[
    Expanded(
      child: _buildStatItem(
        'Employee',
        CurrentRandom.getIntRandom(4, 12).toString(),
        Icons.people,
        Colors.blue,
      ),
    ),
    Expanded(
      child: _buildStatItem(
        'Active Employee',
        CurrentRandom.getIntRandom(0, 12).toString(),
        Icons.today,
        Colors.green,
      ),
    ),
  ];

  Widget _buildStatItem(
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
}
