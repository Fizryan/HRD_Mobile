import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/hrd_c.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/user_m.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPendingRequests();
  }

  void _loadPendingRequests() {}

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
}
