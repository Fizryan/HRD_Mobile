import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_data_c.dart';
import 'package:hrd_system_project/controllers/variable.dart';
import 'package:hrd_system_project/data/user_color.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/widgets/general_w.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatefulWidget {
  final User user;
  const AdminPanel({super.key, required this.user});
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final InfoStatusState _infoStatusHelper = InfoStatusState();

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

  // #region build
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, hrdController, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GeneralWidget().buildStatsHeader(
                  headerChildrens(hrdController.employeeList.length),
                  widget.user,
                ),
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
                          indicatorColor: ColorUser().getColor(
                            widget.user.role,
                          ),
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
                              _buildUserManagement(hrdController),
                              _buildActivityLogs(hrdController.employeeList),
                              _buildSystemManagement(),
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
      },
    );
  }
  // #endregion

  // #region header
  List<Widget> headerChildrens(int totalUsers) => <Widget>[
    Expanded(
      child: GeneralWidget().buildStatItem(
        context,
        'Total Users',
        totalUsers.toString(),
        Icons.people,
        Colors.blue,
      ),
    ),
    Expanded(
      child: GeneralWidget().buildStatItem(
        context,
        'Active User',
        '12',
        Icons.today,
        Colors.green,
      ),
    ),
    Expanded(
      child: GeneralWidget().buildStatItem(
        context,
        'System Status',
        'Normal',
        Icons.check_circle,
        Colors.blue,
      ),
    ),
  ];
  // #endregion

  // #region user management
  Widget _buildUserManagement(UserController hrdController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showUserForm(),
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
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: hrdController.employeeList.map((user) {
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
                              Text(user.name),
                            ],
                          ),
                        ),
                        DataCell(Text(user.role.name)),
                        DataCell(Text('Rp.${user.salary}')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue[700],
                                ),
                                onPressed: () =>
                                    _showUserForm(userToEdit: user),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red[700],
                                ),
                                onPressed: () => _handleDeleteUser(user),
                                tooltip: 'Hapus',
                              ),
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
  // #endregion

  // #region activity logs
  Widget _buildActivityLogs(List<User> filteredUsers) {
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
                  if (filteredUsers.isNotEmpty)
                    for (var i = 0; i < 5; i++)
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
                              filteredUsers[CurrentRandom.getIntRandom(
                                    0,
                                    filteredUsers.length - 1,
                                  )]
                                  .name,
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
  // #endregion

  // #region system management
  Widget _buildSystemManagement() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
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
              children: systemInfoChildrens,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showClearDataConfirmationDialog,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Clear App Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // #endregion

  // #region system info
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
  // #endregion

  // #region user form
  void _showUserForm({User? userToEdit}) {
    final formKey = GlobalKey<FormState>();
    bool isEditMode = userToEdit != null;

    final usernameController = TextEditingController(
      text: userToEdit?.username ?? '',
    );
    final passwordController = TextEditingController(
      text: userToEdit?.password ?? '',
    );
    final nameController = TextEditingController(text: userToEdit?.name ?? '');
    final salaryController = TextEditingController(
      text: userToEdit?.salary.toString() ?? '',
    );

    UserRole? selectedRole = userToEdit?.role;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditMode ? 'Edit User' : 'Add User',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Username cannot be empty'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Password cannot be empty'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter name',
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name cannot be empty'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: salaryController,
                        decoration: const InputDecoration(
                          labelText: 'Salary',
                          hintText: 'Enter salary',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Salary cannot be empty'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<UserRole>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          hintText: 'Select role',
                        ),
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem<UserRole>(
                            value: role,
                            child: Text(role.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedRole = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Role cannot be empty' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        child: Text(isEditMode ? 'Save' : 'Add'),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final hrdController = context
                                .read<UserController>();
                            if (isEditMode) {
                              await hrdController.updateUser(
                                userToEdit: userToEdit,
                                username: usernameController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                role: selectedRole!,
                                salary: double.parse(salaryController.text),
                              );
                            } else {
                              await hrdController.addUser(
                                username: usernameController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                role: selectedRole!,
                                salary: double.parse(salaryController.text),
                              );
                            }
                            final status = isEditMode
                                ? InfoStatus.updated
                                : InfoStatus.created;
                            if (!mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'User data ${isEditMode ? 'updated' : 'added'}.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: _infoStatusHelper
                                    .getInfoStatusColor(status),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  // #endregion

  // #region delete user
  void _handleDeleteUser(User user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: _infoStatusHelper.getInfoStatusColor(
                    InfoStatus.deleted,
                  ),
                ),
              ),
              onPressed: () async {
                final hrdController = context.read<UserController>();
                await hrdController.deleteUser(user);

                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User ${user.name} has been deleted.'),
                    backgroundColor: _infoStatusHelper.getInfoStatusColor(
                      InfoStatus.deleted,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  // #endregion

  // #region clear data
  void _showClearDataConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Clear App Data'),
          content: Text(
            'Are you sure you want to clear all app data? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Clear Data',
                style: TextStyle(
                  color: _infoStatusHelper.getInfoStatusColor(
                    InfoStatus.deleted,
                  ),
                ),
              ),
              onPressed: () async {
                final hrdController = context.read<UserController>();
                await hrdController.clearAllData();

                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All app data has been cleared.'),
                    backgroundColor: _infoStatusHelper.getInfoStatusColor(
                      InfoStatus.deleted,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  // #endregion
}