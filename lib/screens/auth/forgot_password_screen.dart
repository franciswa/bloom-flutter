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

/// Forgot password screen
class ForgotPasswordScreen extends StatefulWidget {
  /// Creates a new [ForgotPasswordScreen] instance
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.resetPassword(
        email: _emailController.text.trim(),
      );

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
        title: const Text('Forgot Password'),
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
            title: 'Forgot Password',
            subtitle: 'Enter your email to reset your password',
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: Validators.validateEmail,
            autofillHints: const [AutofillHints.email],
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
          'Reset Link Sent',
          style: TextStyles.headline4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We have sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions to reset your password.',
          style: TextStyles.body1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Back to Login',
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
