import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routes/app_router.dart';
import '../core/theme/constant/pulse_now_colors.dart';

/// Splash screen with scale animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    // Navigate to dashboard after animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        context.go(AppRouter.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseNowColors.darkBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: PulseNowColors.darkSurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset(
                  'assets/images/pulse-logo.jpeg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

