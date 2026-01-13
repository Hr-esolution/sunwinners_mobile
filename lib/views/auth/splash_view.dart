import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    // Logo rotation animation

    // Slide up animation for content
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Scale animation for particles effect
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final authController = Get.find<AuthController>();
    bool isAuthenticated = await authController.checkAuthStatus();

    if (isAuthenticated) {
      String route = authController.userRole.isNotEmpty
          ? '/${authController.userRole}/dashboard'
          : '/login';
      Get.offAllNamed(route);
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            Positioned.fill(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: CustomPaint(painter: ParticlePainter()),
              ),
            ),

            // Main content
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _controller,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with rotation
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: const Interval(
                                0.0,
                                0.7,
                                curve: Curves.easeInOutCirc,
                              ),
                            ),
                          ),
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(
                                    0xFFffd60a,
                                  ).withValues(alpha: 0.15),
                                  const Color(
                                    0xFFffc300,
                                  ).withValues(alpha: 0.08),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(
                                  0xFFffd60a,
                                ).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFffd60a,
                                  ).withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/sunwinners_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Main title with gradient
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              const Color(0xFFffd60a),
                              const Color(0xFFffc300),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Sunwinners',
                            style: AppTypography.h1.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle with animation
                        Text(
                          'Énergie solaire intelligente',
                          style: AppTypography.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // Loading indicator
                        SizedBox(
                          width: 100,
                          height: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFFffd60a).withValues(alpha: 0.7),
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Status text
                        Text(
                          'Chargement...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                            letterSpacing: 1,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Floating accent elements
            Positioned(
              top: 80,
              right: 20,
              child: _buildFloatingCircle(size: 60, opacity: 0.08),
            ),
            Positioned(
              bottom: 120,
              left: 20,
              child: _buildFloatingCircle(size: 40, opacity: 0.06),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            const Color(0xFFffd60a).withValues(alpha: opacity),
            const Color(0xFFffc300).withValues(alpha: opacity * 0.5),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFffd60a).withValues(alpha: 0.05)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 30; i++) {
      final x = (size.width * (i * 0.0667)) % size.width;
      final y = (size.height * (i * 0.0433)) % size.height;
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => false;
}
