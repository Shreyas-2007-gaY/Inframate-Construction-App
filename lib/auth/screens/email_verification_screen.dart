import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  final VoidCallback onVerificationComplete;
  final VoidCallback onSignOut;

  const EmailVerificationScreen({
    super.key,
    required this.onVerificationComplete,
    required this.onSignOut,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _timer;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 1) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
        setState(() => _resendCooldown = 0);
      }
    });
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      _isChecking = true;
      _message = null;
    });

    try {
      await AuthService.instance.reloadUser();
      final user = AuthService.instance.currentUser;
      if (user != null && user.emailVerified) {
        if (mounted) {
          setState(() {
            _isChecking = false;
            _message = 'Email verified successfully!';
            _isError = false;
          });
          widget.onVerificationComplete();
        }
      } else {
        if (mounted) {
          setState(() {
            _isChecking = false;
            _message = 'Email not yet verified. Please check your inbox and click the link.';
            _isError = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChecking = false;
          _message = 'Verification check failed. Please try again.';
          _isError = true;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResending = true;
      _message = null;
    });

    try {
      await AuthService.instance.sendEmailVerification();
      if (mounted) {
        setState(() {
          _isResending = false;
          _message = 'Verification link resent! Please check your spam/inbox.';
          _isError = false;
        });
        _startCooldown();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResending = false;
          _message = 'Failed to resend link. Please wait before retrying.';
          _isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? 'your email';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFF14213D)),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Color(0xFF14213D), fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14213D).withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge / Icon
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8956C).withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC8956C).withOpacity(0.3), width: 1.5),
                      ),
                      child: const Icon(
                        Icons.forward_to_inbox_rounded,
                        color: Color(0xFFC8956C),
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Verify Your Work Email',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14213D),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600, height: 1.5),
                        children: [
                          const TextSpan(text: 'We\'ve dispatched an activation link to:\n'),
                          TextSpan(
                            text: email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF14213D),
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: '\nTap the link in your inbox to confirm your corporate credentials.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status / Feedback message
                    if (_message != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _isError ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isError ? const Color(0xFFFCA5A5) : const Color(0xFFA7F3D0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                              color: _isError ? const Color(0xFFDC2626) : const Color(0xFF059669),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _message!,
                                style: TextStyle(
                                  color: _isError ? const Color(0xFFB91C1C) : const Color(0xFF047857),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Action 1: Check status
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isChecking ? null : _checkVerificationStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14213D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isChecking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'I Have Verified',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action 2: Resend
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: (_isResending || _resendCooldown > 0) ? null : _resendVerificationEmail,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isResending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                _resendCooldown > 0
                                    ? 'Resend Link in ${_resendCooldown}s'
                                    : 'Resend Verification Email',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _resendCooldown > 0 ? Colors.grey : const Color(0xFFC8956C),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action 3: Continue anyway for development/testing
                    TextButton(
                      onPressed: widget.onVerificationComplete,
                      child: Text(
                        'Continue to Dashboard (Verify Later)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
