// lib/main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmfcode/firebase_options.dart';

import 'app/modules/auth/auth_controller.dart';
import 'app/modules/auth/auth_view.dart';
import 'app/modules/dashboard/dashboard_view.dart';
import 'app/modules/notifications/notification_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Put the AuthController into memory permanently so it can be accessed anywhere.
  Get.put(AuthController(), permanent: true);
  Get.put(NotificationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gamified Coding App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // We use `home` to handle the initial auth check instead of `initialRoute`.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for the auth state.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If the user is logged in AND their email is verified...
          if (snapshot.hasData && snapshot.data!.emailVerified) {
            // ...go to the dashboard.
            return DashboardView();
          } else {
            // ...otherwise, go to the authentication screen.
            return AuthView();
          }
        },
      ),
      // getPages is still needed for named routing throughout the app.
      getPages: AppPages.routes,
    );
  }
}