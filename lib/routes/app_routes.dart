import 'package:afrik_flow/screens/auth/login_screen.dart';
import 'package:afrik_flow/screens/auth/register_screen.dart';
import 'package:afrik_flow/screens/splashs/splash_screen.dart';
import 'package:afrik_flow/widgets/auth_base_screen.dart';
import 'package:afrik_flow/widgets/base_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/screens/home_screen.dart';
import 'package:afrik_flow/screens/send_screen.dart';
import 'package:afrik_flow/screens/transactions_screen.dart';
import 'package:afrik_flow/screens/profile_screen.dart';

class AppRoutes {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthBaseScreen(
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
        path: '/send',
        builder: (context, state) => const BaseScreen(
          currentIndex: 1,
          child: SendScreen(),
        ),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const BaseScreen(
          currentIndex: 2,
          child: TransactionsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const BaseScreen(
          currentIndex: 3,
          child: ProfileScreen(),
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
    ],
  );
}
