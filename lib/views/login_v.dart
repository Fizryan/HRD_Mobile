import 'package:flutter/material.dart';
import 'package:hrd_system_project/controllers/login_c.dart';
import 'package:hrd_system_project/models/status_m.dart';
import 'package:hrd_system_project/variables/color_data.dart';
import 'package:hrd_system_project/views/general_v.dart';
import 'package:provider/provider.dart';
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

  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    context.read<LoginController>().addListener(_onLoginStatusChanged);
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    context.read<LoginController>().removeListener(_onLoginStatusChanged);
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.2,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BackgroundClipper(),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.firstLinear, AppColor.secondLinear],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: (size.height * 0.1) - 40,
            left: 0,
            right: 0,
            child: const Text(
              'HR-Connect',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.only(top: size.height * 0.25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildheader(context),
                    const SizedBox(height: 16),
                    _buildUsernameField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    Consumer<LoginController>(
                      builder: (context, controller, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildErrorMessage(controller),
                            _buildLoginButton(context, controller),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildheader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_person_outlined,
          size: 80,
          color: AppColor.textColor,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColor.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Login to your account',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColor.textColor),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: const TextStyle(color: AppColor.textColor),
      textInputAction: TextInputAction.next,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColor.textColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.textColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: StatusColor.errorColor, width: 2),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
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
      style: const TextStyle(color: AppColor.textColor),
      obscureText: _isPasswordObscured,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) => _login(context),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColor.textColor, fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_open_outlined,
          color: AppColor.textColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColor.textColor,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColor.textColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.textColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: StatusColor.errorColor, width: 2),
        ),
        errorStyle: const TextStyle(color: AppColor.textColor, fontSize: 12),
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
    String message = '';
    Color color = Colors.transparent;

    if (loginController.status == LoginStatus.failed) {
      message = loginController.errorMessage;
      color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 14),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    LoginController loginController,
  ) {
    final childContent = loginController.status == LoginStatus.loading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: AppColor.background,
              strokeWidth: 3,
            ),
          )
        : const Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.background,
            ),
          );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      onPressed: loginController.status == LoginStatus.loading
          ? null
          : () => _login(context),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF007BFF), Color(0xFF0056B3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: childContent,
        ),
      ),
    );
  }
}

// #endregion
