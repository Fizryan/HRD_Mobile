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

class _UserManagementViewState extends State<UserManagementView>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  String _formatCurrency(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final filteredUsers = userProvider.users.where((user) {
          final nameLower = user.name.toLowerCase();
          final usernameLower = user.username.toLowerCase();
          final roleLower = user.role.name.toLowerCase();
          final searchLower = _searchQuery.toLowerCase();

          return nameLower.contains(searchLower) ||
              usernameLower.contains(searchLower) ||
              roleLower.contains(searchLower);
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 16),
              _buildSearchBar(theme),
              const SizedBox(height: 16),
              Text(
                "Total Active Users: ${filteredUsers.length}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredUsers.isEmpty && _searchQuery.isEmpty
                    ? const Center(child: Text('No users found in the system.'))
                    : filteredUsers.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                        child: Text('No users match your search criteria.'),
                      )
                    : ListView.separated(
                        itemCount: filteredUsers.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return _buildUserListItem(
                            context,
                            theme,
                            user,
                            userProvider,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authenticated as',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColor.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.currentUser.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
            ),
            Text(
              widget.currentUser.role.name.toUpperCase(),
              style: TextStyle(
                color: UserColor.getColorByRole(widget.currentUser.role),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddEditUserDialog(context, theme, null),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add User'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.firstLinear,
            foregroundColor: AppColor.textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }
  // #endregion

  // #region search bar
  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by Name, Username, or Role',
        prefixIcon: const Icon(Icons.search, color: AppColor.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColor.borderShadow,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  // #endregion

  // #region user list item
  Widget _buildUserListItem(
    BuildContext context,
    ThemeData theme,
    User user,
    UserProvider userProvider,
  ) {
    return Dismissible(
      key: ValueKey(user.username),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColor.clipperBackground,
        child: const Icon(Icons.delete_forever, color: AppColor.textSecColor),
      ),
      confirmDismiss: (direction) async {
        return await _showConfirmDeleteDialog(context, user);
      },
      onDismissed: (direction) {
        userProvider.deleteUser(user.username);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User ${user.name} deleted')));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: UserColor.getColorByRole(user.role),
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(color: AppColor.textColor),
          ),
        ),
        title: Text(
          user.name,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColor.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${user.username}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.textColor,
              ),
            ),
            Text(
              'Passwprd: ${'*' * user.password.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.textColor,
              ),
            ),
            Text(
              'Salary: ${_formatCurrency(user.salary)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.textColor,
              ),
            ),
            Text(
              'Role: ${user.role.name}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColor.textColor,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: AppColor.textColor),
          onPressed: () => _showAddEditUserDialog(context, theme, user),
        ),
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
          title: const Text('Confirm Deletion'),
          backgroundColor: AppColor.background,
          content: Text('Are you sure you want to delete user ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColor.textColor),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.clipperBackground,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColor.textSecColor),
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
    final isEditing = existingUser != null;
    final formKey = GlobalKey<FormState>();

    final usernameController = TextEditingController(
      text: isEditing ? existingUser.username : '',
    );
    final nameController = TextEditingController(
      text: isEditing ? existingUser.name : '',
    );
    final passwordController = TextEditingController(
      text: isEditing ? '*******' : '',
    );
    UserRole selectedRole = isEditing ? existingUser.role : UserRole.employee;
    final salaryController = TextEditingController(
      text: isEditing ? existingUser.salary.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.background,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing
                        ? 'Edit User ${existingUser.name}'
                        : 'Add New User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14,
                      ),
                      helperStyle: TextStyle(
                        color: AppColor.textColor.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColor.textColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.secondLinear,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
                    ),
                    enabled: !isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14,
                      ),
                      helperStyle: TextStyle(
                        color: AppColor.textColor.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.assignment_ind_outlined,
                        color: AppColor.textColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.secondLinear,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14,
                      ),
                      helperStyle: TextStyle(
                        color: AppColor.textColor.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.password_outlined,
                        color: AppColor.textColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.secondLinear,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (!isEditing && (value == null || value.isEmpty)) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField2<UserRole>(
                    value: selectedRole,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      labelStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14,
                      ),
                      helperStyle: TextStyle(
                        color: AppColor.textColor.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.supervised_user_circle_outlined,
                        color: AppColor.textColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.secondLinear,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
                    ),
                    hint: Text(
                      'Select Role',
                      style: TextStyle(color: AppColor.textColor),
                    ),
                    items: UserRole.values.map((role) {
                      return DropdownMenuItem<UserRole>(
                        value: role,
                        child: Text(role.name),
                      );
                    }).toList(),
                    onChanged: (role) {
                      setState(() => selectedRole = role!);
                    },
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: AppColor.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: salaryController,
                    decoration: InputDecoration(
                      labelText: 'Salary',
                      labelStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 14,
                      ),
                      helperStyle: TextStyle(
                        color: AppColor.textColor.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: AppColor.textColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.textColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.secondLinear,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: AppColor.textColor,
                        fontSize: 12,
                      ),
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
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
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
                      onPressed: () => _saveUser(
                        context,
                        isEditing,
                        existingUser,
                        formKey,
                        usernameController.text.trim(),
                        nameController.text,
                        passwordController.text,
                        selectedRole,
                        salaryController.text,
                      ),
                      child: Text(isEditing ? 'Save Changes' : 'Add User'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // #endregion

  // #region validate and save user
  void _saveUser(
    BuildContext context,
    bool isEditing,
    User? existingUser,
    GlobalKey<FormState> formKey,
    String username,
    String name,
    String password,
    UserRole role,
    String salaryText,
  ) async {
    if (formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String finalPassword;
      if (isEditing) {
        finalPassword = (password == '*******')
            ? existingUser!.password
            : password;
      } else {
        finalPassword = password;
      }

      final newUser = User(
        username: username,
        password: finalPassword,
        name: name,
        role: role,
        salary: double.parse(salaryText),
      );

      try {
        if (isEditing) {
          await userProvider.updateUser(newUser);
          if (!context.mounted) return;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User ${newUser.name} updated successfully'),
            ),
          );
        } else {
          if (userProvider.users.any((u) => u.username == username)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Username $username already exists')),
            );
            return;
          }
          await userProvider.addUser(newUser);
          if (!context.mounted) return;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User ${newUser.name} added successfully')),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    }
  }
}
// #endregion