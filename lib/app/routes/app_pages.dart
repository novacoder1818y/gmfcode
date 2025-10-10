// lib/routes/app_pages.dart

import 'package:get/get.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/challenges/challenge_detail_view.dart';
import '../modules/challenges/challenges_binding.dart';
import '../modules/challenges/challenges_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/event/event_binding.dart';
import '../modules/event/event_view.dart';
import '../modules/feed/feed_binding.dart';
import '../modules/feed/feed_view.dart';
import '../modules/leaderboard/leaderboard_binding.dart';
import '../modules/leaderboard/leaderboard_view.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_view.dart';
import '../modules/practice/practice_binding.dart';
import '../modules/practice/practice_problems_view.dart';
import '../modules/practice/practice_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/public_profile/public_profile_binding.dart'; // <-- IMPORTED BINDING
import '../modules/public_profile/public_profile_view.dart';   // <-- IMPORTED VIEW

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: Routes.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: Routes.CHALLENGES,
      page: () => ChallengesView(),
      binding: ChallengesBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.CHALLENGE_DETAIL,
      page: () => ChallengeDetailView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.EVENT,
      page: () => EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: Routes.LEADERBOARD,
      page: () => LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    // THIS IS THE NEW ROUTE FOR PUBLIC PROFILES
    GetPage(
      name: Routes.PUBLIC_PROFILE,
      page: () => PublicProfileView(),
      binding: PublicProfileBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.FEED,
      page: () => FeedView(),
      binding: FeedBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE,
      page: () => PracticeView(),
      binding: PracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_PROBLEMS,
      page: () => PracticeProblemsView(),
    ),
  ];
}