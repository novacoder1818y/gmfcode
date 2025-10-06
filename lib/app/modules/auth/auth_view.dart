import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmfcode/app/modules/auth/signup.dart';
import '../../theme/app_theme.dart';
import 'auth_controller.dart';
import 'login.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  late AnimationController _purpleController;
  late Animation<double> _purpleAnimation;
  late AnimationController _greenController;
  late Animation<double> _greenAnimation;
  late AnimationController _blueController;
  late Animation<double> _blueAnimation;

  @override
  void initState() {
    super.initState();
    _purpleController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _purpleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_purpleController);

    _greenController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);
    _greenAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_greenController);

    _blueController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat(reverse: true);
    _blueAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_blueController);
  }

  @override
  void dispose() {
    _purpleController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The AuthController is now available via GetX
    final AuthController authController = Get.find();

    return Scaffold(
      body: Stack(
        children: [
          // The dynamic "aurora" background from your original file
          AnimatedBuilder(
            animation: Listenable.merge([_purpleAnimation, _greenAnimation, _blueAnimation]),
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-1.0 + _purpleAnimation.value * 2, -1.0 + _purpleAnimation.value * 2),
                    radius: 1.5,
                    colors: const [AppTheme.secondaryColor, AppTheme.primaryColor],
                    stops: const [0.0, 0.9],
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(1.0 - _greenAnimation.value * 2, 1.0 - _greenAnimation.value * 2),
                          radius: 1.2,
                          colors: const [AppTheme.accentColor, Colors.transparent],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(_blueAnimation.value * 0.2 - 0.1, -1.0 + _blueAnimation.value * 2),
                          radius: 1.0,
                          colors: [AppTheme.tertiaryColor, Colors.transparent],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // UI Content on top of the background
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.code_rounded, size: 60, color: Colors.white),
                      const SizedBox(height: 50),
                      // Animated Switcher for Login/Signup forms
                      Obx(
                            () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: authController.isLogin.value
                              ? const LoginWidget(key: ValueKey('login'))
                              : const SignupWidget(key: ValueKey('signup')),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Toggle Button
                      Obx(
                            () => TextButton(
                          onPressed: authController.toggleForm,
                          child: Text(
                            authController.isLogin.value
                                ? "Don't have an account? Sign Up"
                                : "Already have an account? Login",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}