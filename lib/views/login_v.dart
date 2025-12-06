import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';

// #region login widget
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  String _appVersion = '';

  Timer? _errorTimer;
  LoginController? _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = context.read<LoginController>();
    _loginController?.addListener(_onLoginStatusChanged);
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${packageInfo.version}+${packageInfo.buildNumber}';
      });
    }
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _loginController?.removeListener(_onLoginStatusChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginStatusChanged() {
    if (!mounted) return;

    final controller = context.read<LoginController>();

    _errorTimer?.cancel();

    if (controller.status == LoginStatus.failed) {
      _errorTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          controller.resetStatus();
        }
      });
    }
  }

  void _login(BuildContext context) {
    FocusScope.of(context).unfocus();
    _usernameController.text = _usernameController.text.trim();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginController>().login(
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.buttonPrimary.withValues(alpha: 0.2),
                    AppColor.buttonPrimary.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.secondLinear.withValues(alpha: 0.2),
                    AppColor.firstLinear.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildLoginCard(),
                      const SizedBox(height: 40),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColor.buttonPrimary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.business_center,
            size: 40,
            color: AppColor.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'HR-Connect',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Human Resource Management System',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColor.grey600),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black87.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColor.textColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildUsernameField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 20),
          Consumer<LoginController>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  _buildErrorMessage(controller),
                  _buildLoginButton(controller),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: const TextStyle(color: AppColor.textColor, fontSize: 15),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: AppColor.grey600, fontSize: 14),
        hintText: 'Enter your username',
        hintStyle: TextStyle(color: AppColor.grey400, fontSize: 14),
        prefixIcon: const Icon(
          Icons.person_outline,
          color: AppColor.buttonPrimary,
          size: 22,
        ),
        filled: true,
        fillColor: AppColor.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColor.buttonPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: StatusColor.errorColor,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: StatusColor.errorColor,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(color: AppColor.textColor, fontSize: 15),
      obscureText: _isPasswordObscured,
      obscuringCharacter: '•',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
        _usernameController.text = _usernameController.text.trim();
        if (_formKey.currentState?.validate() ?? false) {
          context.read<LoginController>().login(
            _usernameController.text,
            _passwordController.text,
          );
        }
      },
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColor.grey600, fontSize: 14),
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: AppColor.grey400, fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColor.buttonPrimary,
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColor.grey600,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
        filled: true,
        fillColor: AppColor.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColor.buttonPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: StatusColor.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: StatusColor.errorColor,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: StatusColor.errorColor,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildErrorMessage(LoginController loginController) {
    if (loginController.status != LoginStatus.failed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: StatusColor.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: StatusColor.errorColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              loginController.errorMessage,
              style: const TextStyle(
                color: StatusColor.errorColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginController loginController) {
    final isLoading = loginController.status == LoginStatus.loading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.buttonPrimary,
          foregroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : () => _login(context),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColor.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      _appVersion.isEmpty
          ? 'HR-Connect Management System vLoading...'
          : 'HR-Connect Management System $_appVersion',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: AppColor.grey600),
    );
  }
}

// #endregion
