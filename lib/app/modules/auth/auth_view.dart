// lib/app/modules/auth/auth_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

// Use TickerProviderStateMixin to handle multiple AnimationControllers
class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  // Controller for the purple blob
  late AnimationController _purpleController;
  late Animation<double> _purpleAnimation;

  // Controller for the green blob
  late AnimationController _greenController;
  late Animation<double> _greenAnimation;

  // NEW: Controller for the new blue blob
  late AnimationController _blueController;
  late Animation<double> _blueAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the purple controller
    _purpleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _purpleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_purpleController);

    // Initialize the green controller
    _greenController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _greenAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_greenController);

    // NEW: Initialize the new blue controller with another unique duration
    _blueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
    _blueAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_blueController);
  }

  @override
  void dispose() {
    _purpleController.dispose();
    _greenController.dispose();
    _blueController.dispose(); // Dispose the new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated glowing background effects
          AnimatedBuilder(
            // Listen to all three animations
            animation: Listenable.merge([_purpleAnimation, _greenAnimation, _blueAnimation]),
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    // Purple Blob
                    center: Alignment(-1.0 + _purpleAnimation.value * 2, -1.0 + _purpleAnimation.value * 2),
                    radius: 1.5,
                    colors: const [
                      AppTheme.secondaryColor,
                      AppTheme.primaryColor,
                    ],
                    stops: const [0.0, 0.9],
                  ),
                ),
                child: Stack( // Use a Stack to layer the next two blobs
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          // Green Blob
                          center: Alignment(1.0 - _greenAnimation.value * 2, 1.0 - _greenAnimation.value * 2),
                          radius: 1.2,
                          colors: const [
                            AppTheme.accentColor,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                    // NEW: Add the third blob (Blue)
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          // Blue Blob - moves up and down the middle
                          center: Alignment(_blueAnimation.value * 0.2 - 0.1, -1.0 + _blueAnimation.value * 2),
                          radius: 1.0,
                          colors: [
                            AppTheme.tertiaryColor,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Your original UI content remains on top
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.code_rounded,
                    size: 80,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 15, color: AppTheme.accentColor)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'CODE STREAK',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: AppTheme.accentColor,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  NeonButton(
                    text: 'Login with Google',
                    onTap: () => Get.offAllNamed(Routes.DASHBOARD),
                    icon: Icons.g_mobiledata,
                    gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor],
                  ),
                  const SizedBox(height: 20),
                  NeonButton(
                    text: 'Login with Email',
                    onTap: () => Get.offAllNamed(Routes.DASHBOARD),
                    icon: Icons.email_outlined,
                    gradientColors: const [AppTheme.secondaryColor, AppTheme.tertiaryColor],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}