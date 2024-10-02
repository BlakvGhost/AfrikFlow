import 'package:afrik_flow/screens/auth/email_verification_screen.dart';
import 'package:afrik_flow/screens/auth/login_screen.dart';
import 'package:afrik_flow/screens/auth/register_screen.dart';
import 'package:afrik_flow/screens/auth/two_factor_screen.dart';
import 'package:afrik_flow/screens/notifications_screen.dart';
import 'package:afrik_flow/screens/settings_screen.dart';
import 'package:afrik_flow/screens/splashs/splash_screen.dart';
import 'package:afrik_flow/widgets/auth_base_screen.dart';
import 'package:afrik_flow/widgets/base_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/screens/home_screen.dart';
import 'package:afrik_flow/screens/send_screen.dart';
import 'package:afrik_flow/screens/transactions_screen.dart';
import 'package:afrik_flow/screens/profile_screen.dart';

class AppRoutes {
  static final routes = [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthBaseScreen(
        isFullScreen: true,
        child: SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const BaseScreen(
        currentIndex: 0,
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Notifications",
        child: NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: '/send',
      builder: (context, state) => const BaseScreen(
        currentIndex: 2,
        showAppBar: false,
        title: "Envoyer de l'argent",
        child: SendScreen(),
      ),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => BaseScreen(
        currentIndex: 1,
        showAppBar: false,
        title: "Historiques",
        child: TransactionsScreen(),
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const BaseScreen(
        currentIndex: 3,
        showAppBar: false,
        title: "Mon Profile",
        child: ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const BaseScreen(
        currentIndex: 4,
        showAppBar: false,
        title: "Reglage",
        child: SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthBaseScreen(
        child: LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthBaseScreen(
        child: RegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/email-verification',
      builder: (context, state) => AuthBaseScreen(
        child: EmailVerificationScreen(
          email: state.extra as String,
        ),
      ),
    ),
    GoRoute(
      path: '/two-factor-verification',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>;
        final email = extraData['email'] as String;
        final password = extraData['password'] as String;

        return AuthBaseScreen(
          child: TwoFactorScreen(
            email: email,
            password: password,
          ),
        );
      },
    ),
  ];
}
