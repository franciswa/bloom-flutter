import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';

/// Email verification screen
class EmailVerificationScreen extends StatefulWidget {
  /// Email
  final String? email;

  /// Creates a new [EmailVerificationScreen] instance
  const EmailVerificationScreen({
    super.key,
    this.email,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  int _resendCountdown = 0;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // Check verification status every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final isVerified = await authProvider.checkEmailVerification();

      if (!mounted) return;

      if (isVerified) {
        _timer?.cancel();
        context.go(AppRoutes.onboarding);
      }
    } catch (e) {
      // Ignore errors during automatic checks
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCountdown > 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.resendVerificationEmail();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
        ),
      );

      // Start countdown for resend button
      setState(() {
        _resendCountdown = 60;
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendCountdown > 0) {
          setState(() {
            _resendCountdown--;
          });
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      if (!mounted) return;

      UIHelpers.showErrorDialog(
        context: context,
        title: 'Resend Failed',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  Future<void> _manuallyVerify() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      await _checkVerificationStatus();
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.signOut();

      if (!mounted) return;

      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;

      UIHelpers.showErrorDialog(
        context: context,
        title: 'Sign Out Failed',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email ??
        Provider.of<AuthProvider>(context).currentUser?.email ??
        'your email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  color: AppColors.primary,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verify Your Email',
                  style: TextStyles.headline4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We\'ve sent a verification email to $email. Please check your inbox and click the verification link to continue.',
                  style: TextStyles.body1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _isVerifying
                    ? const LoadingIndicator()
                    : CustomButton(
                        text: 'I\'ve Verified My Email',
                        onPressed: _manuallyVerify,
                      ),
                const SizedBox(height: 16),
                CustomButton(
                  text: _resendCountdown > 0
                      ? 'Resend Email (${_resendCountdown}s)'
                      : 'Resend Verification Email',
                  onPressed:
                      _resendCountdown > 0 ? null : _resendVerificationEmail,
                  type: ButtonType.outline,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Didn\'t receive the email? Check your spam folder or try resending the verification email.',
                  style: TextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
