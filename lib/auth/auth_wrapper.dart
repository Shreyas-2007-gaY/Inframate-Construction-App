import 'package:flutter/material.dart';
import '../main.dart';
import 'auth_service.dart';
import 'screens/email_verification_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';

/// Gatekeeper widget that routes users based on active Firebase authentication state.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSignIn = true;
  bool _bypassEmailVerification = false;

  void _toggleView() {
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // While waiting for initial auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FC),
            body: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14213D)),
                ),
              ),
            ),
          );
        }

        final user = snapshot.data;

        // User is authenticated
        if (user != null) {
          // If email is not verified and user hasn't explicitly clicked continue
          if (!user.emailVerified && !_bypassEmailVerification) {
            return EmailVerificationScreen(
              onVerificationComplete: () {
                setState(() => _bypassEmailVerification = true);
              },
              onSignOut: () async {
                setState(() => _bypassEmailVerification = false);
                await AuthService.instance.signOut();
              },
            );
          }

          // User verified or bypassed: navigate to main dashboard
          return MainConstructionScreen(
            initialUserName: user.displayName,
            initialUserEmail: user.email,
            initialUserRole: user.role,
          );
        }

        // User not authenticated: show Login or Sign Up
        _bypassEmailVerification = false;
        if (_showSignIn) {
          return LoginScreen(onToggleView: _toggleView);
        } else {
          return SignUpScreen(onToggleView: _toggleView);
        }
      },
    );
  }
}
