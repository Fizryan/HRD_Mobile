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

class HrdPanel extends StatefulWidget {
  final User user;
  const HrdPanel({super.key, required this.user});
  @override
  State<HrdPanel> createState() => _HrdPanelState();
}

class _HrdPanelState extends State<HrdPanel>
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
                    req.type != RequestType.claimReimbursment,
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
    final hrdController = context.watch<UserController>();
    int currentEmployee = hrdController.employeeList.length;
    String currentDate = CurrentDate.getDate();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildHeader(context, currentDate: currentDate),
        ),
        TabBar(
          controller: _tabController,
          labelColor: ColorUser().getColor(widget.user.role),
          indicatorColor: ColorUser().getColor(widget.user.role),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Approval'),
            Tab(text: 'Employee'),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TabBarView(
            controller: _tabController,
            children: [
              _dashboardSummary(currentDate, currentEmployee, _tabController),
              _buildApprovalList(),
              _buildEmployeeTab(hrdController),
            ],
          ),
        ),
      ],
    );
  }
  // #endregion

  // #region header
  Widget _buildHeader(BuildContext context, {required String currentDate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                "The following is a summary of today's activities",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorUser().getColor(widget.user.role),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Text(
            currentDate,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ],
    );
  }
  // #endregion

  // #region summary
  Widget _dashboardSummary(
    String currentDate,
    int currentEmployee,
    TabController tabController,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildStatsGrid(
              currentDate: currentDate,
              currentEmployee: currentEmployee,
            ),
            const SizedBox(height: 8),
            ...GeneralWidget().toDoInfoChildrens(
              'Leave Request',
              'New submissions are waiting for your approval.',
              _pendingRequests.length,
              Icon(Icons.chevron_right),
              widget.user,
              tabController,
              Icon(Icons.pending_actions, color: Colors.orange, size: 32),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  // #endregion

  // #region stats grid
  Widget _buildStatsGrid({
    required String currentDate,
    required int currentEmployee,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: crossAxisCount == 2 ? 0.96 : 1,
          children: [
            _buildStatCard(
              title: "Total Employees",
              value: currentEmployee.toString(),
              icon: Icons.people_outline,
              color: Colors.blue,
              change: currentDate,
            ),
            _buildStatCard(
              title: "Pending Leave",
              value: _pendingRequests.length.toString(),
              icon: Icons.beach_access_outlined,
              color: Colors.orange,
              change: "Needs approval",
            ),
            _buildStatCard(
              title: "Today's Attendance",
              value: "${CurrentRandom.getIntRandom(75, 95)}%",
              icon: Icons.fact_check_outlined,
              color: Colors.green,
              change: CurrentDate.getTime(),
            ),
            _buildStatCard(
              title: "Active Training",
              value: CurrentRandom.getIntRandom(0, currentEmployee).toString(),
              icon: Icons.school_outlined,
              color: Colors.purple,
              change: "$currentEmployee participants",
            ),
          ],
        );
      },
    );
  }
  // #endregion

  // #region stat card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorUser().getColor(widget.user.role),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: change.contains("+")
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    change.contains("+") ? "↑" : "!",
                    style: TextStyle(
                      color: change.contains("+")
                          ? Colors.green
                          : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              change,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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

    final allowedRoles = [
      UserRole.employee,
      UserRole.supervisor,
      UserRole.finance,
      UserRole.hrd,
    ];

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
                        isEditMode ? 'Edit Employee' : 'Add Employee',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: usernameController,
                        obscureText: true,
                        readOnly: true,
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
                        readOnly: true,
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
                        readOnly: (userToEdit?.name == widget.user.name)
                            ? true
                            : false,
                        obscureText: (userToEdit?.name == widget.user.name)
                            ? true
                            : false,
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
                        readOnly: (userToEdit?.name == widget.user.name)
                            ? true
                            : false,
                        obscureText: (userToEdit?.name == widget.user.name)
                            ? true
                            : false,
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
                        items: UserRole.values
                            .where((role) => allowedRoles.contains(role))
                            .map((role) {
                              return DropdownMenuItem<UserRole>(
                                value: role,
                                child: Text(role.name),
                              );
                            })
                            .toList(),
                        onChanged:
                            (isEditMode && userToEdit.role == UserRole.hrd)
                            ? null
                            : (value) {
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
                                actorName: widget.user.name,
                              );
                            } else {
                              await hrdController.addUser(
                                username: usernameController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                role: selectedRole!,
                                salary: double.parse(salaryController.text),
                                actorName: widget.user.name,
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
                                  'Data ${isEditMode ? 'updated' : 'added'}.',
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

  // #region employee tab
  Widget _buildEmployeeTab(UserController hrdController) {
    return Scaffold(
      body: _buildEmployeeList(hrdController),
      floatingActionButton: widget.user.role == UserRole.admin
          ? FloatingActionButton(
              onPressed: () => _showUserForm(),
              tooltip: 'Add Employee',
              backgroundColor: ColorUser().getColor(widget.user.role),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
  // #endregion

  // #region employee list
  Widget _buildEmployeeList(UserController hrdController) {
    final employeeList = hrdController.employeeList
        .where((user) => user.role != UserRole.admin)
        .toList();
    if (employeeList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No employees found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: employeeList.length,
      itemBuilder: (context, index) {
        final employee = employeeList[index];
        return _buildEmployeeCard(employee);
      },
    );
  }
  // #endregion

  // #region employee card
  Widget _buildEmployeeCard(User employee) {
    final roleColor = ColorUser().getColor(employee.role);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorUser().getColor(widget.user.role),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: roleColor.withAlpha(50),
          child: Icon(
            employee.role == UserRole.supervisor
                ? Icons.support_agent
                : employee.role == UserRole.finance
                ? Icons.account_balance_wallet
                : Icons.person,
            color: roleColor,
          ),
        ),
        title: Text(
          employee.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('''Salary Rp.${employee.salary.toStringAsFixed(0)}
Role: ${employee.role.name}'''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blue[700]),
              onPressed: () => _showUserForm(userToEdit: employee),
              tooltip: 'Edit',
            ),
            if (widget.user.role == UserRole.admin) ...[
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                onPressed: () => _handleDeleteUser(employee),
                tooltip: 'Delete',
              ),
            ],
          ],
        ),
      ),
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
    final message = 'Submission from ${request.name} has been $status.';
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

  // #region delete user
  void _handleDeleteUser(User user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete Employee'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
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
                await hrdController.deleteUser(user, widget.user.name);

                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Employee ${user.name} has been deleted.'),
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
