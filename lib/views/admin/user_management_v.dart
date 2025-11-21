import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/user_c.dart';
import 'package:hrd_system_project/models/user_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:provider/provider.dart';

class UserManagementView extends StatefulWidget {
  final User currentUser;
  const UserManagementView({super.key, required this.currentUser});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  String _searchQuery = '';
  late final TextEditingController _searchController;
  static final _currencyRegex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(_currencyRegex, (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildHeader(Theme.of(context)), const SizedBox(height: 16)],
      ),
      builder: (context, userProvider, child) {
        final filteredUsers = _searchQuery.isEmpty
            ? userProvider.users
            : userProvider.users.where((user) {
                final searchLower = _searchQuery.toLowerCase();
                return user.name.toLowerCase().contains(searchLower) ||
                    user.username.toLowerCase().contains(searchLower) ||
                    user.role.name.toLowerCase().contains(searchLower);
              }).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              child!,
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildStatisticsCards(userProvider.users, filteredUsers),
              const SizedBox(height: 16),
              Expanded(
                child: filteredUsers.isEmpty && _searchQuery.isEmpty
                    ? const Center(child: Text('No users found in the system.'))
                    : filteredUsers.isEmpty
                    ? const Center(
                        child: Text('No users match your search criteria.'),
                      )
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return _UserListItem(
                            key: ValueKey(user.username),
                            user: user,
                            userProvider: userProvider,
                            formatCurrency: _formatCurrency,
                            onEdit: () => _showAddEditUserDialog(
                              context,
                              Theme.of(context),
                              user,
                            ),
                            onDelete: () async {
                              final confirmed = await _showConfirmDeleteDialog(
                                context,
                                user,
                              );
                              if (confirmed == true) {
                                userProvider.deleteUser(user.username);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete_forever,
                                          color: AppColor.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text('User ${user.name} deleted'),
                                      ],
                                    ),
                                    backgroundColor: AppColor.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // #region header
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UserColor.getColorByRole(widget.currentUser.role),
            UserColor.getColorByRole(
              widget.currentUser.role,
            ).withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.manage_accounts,
                  color: UserColor.getColorByRole(widget.currentUser.role),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Management',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage as ${widget.currentUser.role.name.toUpperCase()}',
                      style: const TextStyle(
                        color: AppColor.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditUserDialog(context, theme, null),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  foregroundColor: UserColor.getColorByRole(
                    widget.currentUser.role,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // #endregion

  Widget _buildStatisticsCards(List<User> allUsers, List<User> filteredUsers) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black87.withValues(alpha: 0.04),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.buttonPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.groups,
                        color: AppColor.buttonPrimary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Total Users',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${allUsers.length}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black87.withValues(alpha: 0.04),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: AppColor.green,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Filtered',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${filteredUsers.length}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // #region search bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by Name, Username, or Role',
          hintStyle: const TextStyle(color: AppColor.grey600, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.grey600,
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColor.grey600,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColor.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  // #endregion

  // #region confirm delete dialog
  Future<bool?> _showConfirmDeleteDialog(
    BuildContext context,
    User user,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_forever,
                  color: AppColor.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Confirm Deletion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: AppColor.white,
          content: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: AppColor.textColor),
              children: [
                const TextSpan(text: 'Are you sure you want to delete user '),
                TextSpan(
                  text: user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.red,
                  ),
                ),
                const TextSpan(text: '? This action cannot be undone.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColor.grey600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.red,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // #endregion

  // #region add/edit user dialog
  void _showAddEditUserDialog(
    BuildContext context,
    ThemeData theme,
    User? existingUser,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.background,
      builder: (dialogContext) => UserFormWidget(
        existingUser: existingUser,
        onSave: (user) {
          Navigator.of(dialogContext).pop();
          _handleSaveUser(user, existingUser != null);
        },
      ),
    );
  }

  // #endregion

  // #region handle save user
  Future<void> _handleSaveUser(User user, bool isEditing) async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (isEditing) {
        await userProvider.updateUser(user);
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('User ${user.name} updated successfully')),
        );
      } else {
        if (userProvider.users.any((u) => u.username == user.username)) {
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text('Username ${user.username} already exists')),
          );
          return;
        }
        await userProvider.addUser(user);
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('User ${user.name} added successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  // #endregion
}

// #region user list item widget
class _UserListItem extends StatelessWidget {
  final User user;
  final UserProvider userProvider;
  final String Function(double) formatCurrency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserListItem({
    required super.key,
    required this.user,
    required this.userProvider,
    required this.formatCurrency,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColor.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever, color: AppColor.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.black87.withValues(alpha: 0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: UserColor.getColorByRole(user.role).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: UserColor.getColorByRole(user.role),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: UserColor.getColorByRole(
                    user.role,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user.role.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: UserColor.getColorByRole(user.role),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 14,
                      color: AppColor.grey600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: AppColor.grey600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 14,
                      color: AppColor.grey600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatCurrency(user.salary),
                      style: const TextStyle(
                        color: AppColor.grey600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: AppColor.buttonPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppColor.buttonPrimary,
                size: 20,
              ),
              onPressed: onEdit,
            ),
          ),
        ),
      ),
    );
  }
}
// #endregion

// #region user form widget
class UserFormWidget extends StatefulWidget {
  final User? existingUser;
  final Function(User) onSave;

  const UserFormWidget({super.key, this.existingUser, required this.onSave});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _salaryController;
  late UserRole _selectedRole;

  bool get _isEditing => widget.existingUser != null;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: _isEditing ? widget.existingUser!.username : '',
    );
    _nameController = TextEditingController(
      text: _isEditing ? widget.existingUser!.name : '',
    );
    _passwordController = TextEditingController(
      text: _isEditing ? '*******' : '',
    );
    _salaryController = TextEditingController(
      text: _isEditing ? widget.existingUser!.salary.toString() : '',
    );
    _selectedRole = _isEditing ? widget.existingUser!.role : UserRole.employee;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      String finalPassword;
      if (_isEditing) {
        finalPassword = (_passwordController.text == '*******')
            ? widget.existingUser!.password
            : _passwordController.text;
      } else {
        finalPassword = _passwordController.text;
      }

      final user = User(
        username: _usernameController.text.trim(),
        password: finalPassword,
        name: _nameController.text,
        role: _selectedRole,
        salary: double.parse(_salaryController.text),
      );

      widget.onSave(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing
                    ? 'Edit User ${widget.existingUser!.name}'
                    : 'Add New User',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              _buildUsernameField(),
              const SizedBox(height: 10),
              _buildNameField(),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 10),
              _buildRoleDropdown(),
              const SizedBox(height: 10),
              _buildSalaryField(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        helperStyle: TextStyle(
          color: AppColor.textColor.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: AppColor.textColor,
        ),
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.secondLinear),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
      ),
      enabled: !_isEditing,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        helperStyle: TextStyle(
          color: AppColor.textColor.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.assignment_ind_outlined,
          color: AppColor.textColor,
        ),
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.secondLinear),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        helperStyle: TextStyle(
          color: AppColor.textColor.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.password_outlined,
          color: AppColor.textColor,
        ),
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.secondLinear),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
      ),
      obscureText: true,
      validator: (value) {
        if (!_isEditing && (value == null || value.isEmpty)) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField2<UserRole>(
      value: _selectedRole,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Select Role',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        helperStyle: TextStyle(
          color: AppColor.textColor.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(
          Icons.supervised_user_circle_outlined,
          color: AppColor.textColor,
        ),
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.secondLinear),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
      ),
      hint: const Text(
        'Select Role',
        style: TextStyle(color: AppColor.textColor),
      ),
      items: UserRole.values.map((role) {
        return DropdownMenuItem<UserRole>(value: role, child: Text(role.name));
      }).toList(),
      onChanged: (role) {
        setState(() => _selectedRole = role!);
      },
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: AppColor.background,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSalaryField() {
    return TextFormField(
      controller: _salaryController,
      decoration: InputDecoration(
        labelText: 'Salary',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        helperStyle: TextStyle(
          color: AppColor.textColor.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(Icons.attach_money, color: AppColor.textColor),
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.secondLinear),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a salary';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondLinear,
          foregroundColor: AppColor.textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _submitForm,
        child: Text(_isEditing ? 'Save Changes' : 'Add User'),
      ),
    );
  }
}
// #endregion