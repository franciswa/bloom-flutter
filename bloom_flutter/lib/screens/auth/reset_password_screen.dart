import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/validators.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_indicator.dart';

/// Reset password screen
class ResetPasswordScreen extends StatefulWidget {
  /// Creates a new [ResetPasswordScreen] instance
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // In a real app, you would get the reset token from the URL
      // For this example, we'll just simulate a successful password reset
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        _isSuccess = true;
      });
    } catch (e) {
      if (!mounted) return;

      UIHelpers.showErrorDialog(
        context: context,
        title: 'Reset Password Failed',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _isSuccess
                ? _buildSuccessContent()
                : _buildResetPasswordForm(isLoading),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: 'Reset Password',
            subtitle: 'Create a new password for your account',
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _passwordController,
            label: 'New Password',
            hintText: 'Enter your new password',
            obscureText: !_isPasswordVisible,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: Validators.validatePassword,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hintText: 'Confirm your new password',
            obscureText: !_isConfirmPasswordVisible,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            validator: (value) => Validators.validateConfirmPassword(
              value,
              _passwordController.text,
            ),
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: 24),
          isLoading
              ? const LoadingIndicator()
              : CustomButton(
                  text: 'Reset Password',
                  onPressed: _resetPassword,
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Remember your password?'),
              TextButton(
                onPressed: () {
                  context.go(AppRoutes.login);
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: AppColors.success,
          size: 80,
        ),
        const SizedBox(height: 24),
        const Text(
          'Password Reset Successful',
          style: TextStyles.headline4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Your password has been reset successfully. You can now sign in with your new password.',
          style: TextStyles.body1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Sign In',
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
