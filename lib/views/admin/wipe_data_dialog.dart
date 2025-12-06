import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:provider/provider.dart';

class WipeDataDialog extends StatefulWidget {
  final String title;
  final String content;
  final Future<void> Function() onConfirm;

  const WipeDataDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  State<WipeDataDialog> createState() => _WipeDataDialogState();
}

class _WipeDataDialogState extends State<WipeDataDialog> {
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (_isLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      if (!mounted) return;
      Navigator.of(context).pop();

      try {
        await widget.onConfirm();
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: StatusColor.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: StatusColor.errorColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            const Text(
              "Enter your password to confirm:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: StatusColor.errorColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColor.grey600,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.grey200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: StatusColor.errorColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: StatusColor.errorColor,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: StatusColor.errorColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                errorStyle: const TextStyle(fontSize: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                // Validator is called in the same build context
                final loginController = context.read<LoginController>();
                if (loginController.loggedInUser?.password != value) {
                  return 'Incorrect password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.white,
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColor.grey600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: StatusColor.errorColor,
            foregroundColor: AppColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _handleConfirm,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
                  ),
                )
              : const Text(
                  "WIPE DATA",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
