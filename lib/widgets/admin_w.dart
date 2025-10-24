import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/data/user_data.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/widgets/general_w.dart';

class AdminPanel extends StatefulWidget {
  final User user;
  const AdminPanel({super.key, required this.user});
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _searchQuery = '';

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
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: ColorUser().getColor(widget.user.role),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: ColorUser().getColor(widget.user.role),
                      indicatorColor: ColorUser().getColor(widget.user.role),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'Users',
                          icon: const Icon(Icons.person_outline_rounded),
                        ),
                        Tab(text: 'Logs', icon: Icon(Icons.history)),
                        Tab(text: 'System', icon: Icon(Icons.settings)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 350,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUserManagement(
                            UserList.getFilteredUsers(_searchQuery),
                          ),
                          _buildActivityLogs(
                            UserList.getFilteredUsers(_searchQuery),
                          ),
                          GeneralWidget().buildSystemInfo(systemInfoChildrens),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get headerChildrens => <Widget>[
    Expanded(
      child: _buildStatItem(
        'Total Users',
        dummyUsers.length.toString(),
        Icons.people,
        Colors.blue,
      ),
    ),
    Expanded(
      child: _buildStatItem('Active User', '12', Icons.today, Colors.green),
    ),
    Expanded(
      child: _buildStatItem(
        'System Status',
        'Normal',
        Icons.check_circle,
        Colors.blue,
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

  Widget _buildUserManagement(List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUser().getColor(widget.user.role),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) => Colors.grey[100],
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Role',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Salary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: users.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: ColorUser().getColor(
                                  user.role,
                                ),
                                child: Text(
                                  user.name.substring(0, 1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(user.displayName),
                            ],
                          ),
                        ),
                        DataCell(Row(children: [Text(user.displayRole)])),
                        DataCell(
                          Row(
                            children: [
                              const SizedBox(width: 4),
                              Text('Rp.${user.salary}'),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLogs(filteredUsers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: [
              const Text(
                'Activity Logs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined, size: 16),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorUser().getColor(widget.user.role),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) => Colors.grey[50],
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'User',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrentDate.getTime(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              CurrentDate.getDate(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${filteredUsers[CurrentRandom.getIntRandom(0, filteredUsers.length - 1)].name}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> get systemInfoChildrens => <Widget>[
    GeneralWidget().buildInfoCard(
      'Server Status',
      'Online',
      Icons.cloud,
      Colors.green,
      context,
    ),
    GeneralWidget().buildInfoCard(
      'Database Status',
      '${CurrentRandom.getIntRandom(5, 45)}%',
      Icons.storage,
      Colors.blue,
      context,
    ),
    GeneralWidget().buildInfoCard(
      'Memory Usage',
      '${CurrentRandom.getIntRandom(7, 70)}%',
      Icons.memory,
      Colors.orange,
      context,
    ),
    GeneralWidget().buildInfoCard(
      'CPU Load',
      '${CurrentRandom.getIntRandom(4, 75)}%',
      Icons.speed,
      Colors.purple,
      context,
    ),
  ];
}
