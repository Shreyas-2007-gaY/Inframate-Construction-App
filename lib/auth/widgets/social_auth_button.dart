import 'package:flutter/material.dart';

/// Clean Google Sign-In button designed to meet Google Brand Guidelines
/// while maintaining the app's minimal luxury style.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14213D)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogleIcon(),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

/// CustomPainter that draws the official 4-color Google "G" emblem.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final paintBlue = Paint()..color = const Color(0xFF4285F4);
    final paintRed = Paint()..color = const Color(0xFFEA4335);
    final paintYellow = Paint()..color = const Color(0xFFFBBC05);
    final paintGreen = Paint()..color = const Color(0xFF34A853);

    // Blue Bar & Arc
    final pathBlue = Path()
      ..moveTo(w * 0.98, h * 0.5)
      ..lineTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.5, h * 0.3)
      ..lineTo(w * 0.96, h * 0.3)
      ..arcToPoint(Offset(w * 0.88, h * 0.75), radius: Radius.circular(w * 0.5));
    canvas.drawPath(pathBlue, paintBlue);

    // Green Arc
    final pathGreen = Path()
      ..moveTo(w * 0.88, h * 0.75)
      ..arcToPoint(Offset(w * 0.32, h * 0.88), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.44, h * 0.68)
      ..arcToPoint(Offset(w * 0.72, h * 0.62), radius: Radius.circular(w * 0.32))
      ..close();
    canvas.drawPath(pathGreen, paintGreen);

    // Yellow Arc
    final pathYellow = Path()
      ..moveTo(w * 0.32, h * 0.88)
      ..arcToPoint(Offset(w * 0.12, h * 0.5), radius: Radius.circular(w * 0.5))
      ..arcToPoint(Offset(w * 0.22, h * 0.22), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.38, h * 0.38)
      ..arcToPoint(Offset(w * 0.32, h * 0.5), radius: Radius.circular(w * 0.28))
      ..arcToPoint(Offset(w * 0.44, h * 0.68), radius: Radius.circular(w * 0.28))
      ..close();
    canvas.drawPath(pathYellow, paintYellow);

    // Red Arc
    final pathRed = Path()
      ..moveTo(w * 0.22, h * 0.22)
      ..arcToPoint(Offset(w * 0.78, h * 0.12), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.64, h * 0.32)
      ..arcToPoint(Offset(w * 0.38, h * 0.38), radius: Radius.circular(w * 0.3))
      ..close();
    canvas.drawPath(pathRed, paintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
