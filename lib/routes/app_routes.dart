import 'package:afrik_flow/models/transaction.dart';
import 'package:afrik_flow/screens/all_service_screen.dart';
import 'package:afrik_flow/screens/assistance_screen.dart';
import 'package:afrik_flow/screens/auth/email_verification_screen.dart';
import 'package:afrik_flow/screens/auth/login_screen.dart';
import 'package:afrik_flow/screens/auth/register_screen.dart';
import 'package:afrik_flow/screens/auth/two_factor_screen.dart';
import 'package:afrik_flow/screens/help/about_screen.dart';
import 'package:afrik_flow/screens/help/help_screen.dart';
import 'package:afrik_flow/screens/invoice_screen.dart';
import 'package:afrik_flow/screens/kyc/kyc_verification_screen.dart';
import 'package:afrik_flow/screens/notifications_screen.dart';
import 'package:afrik_flow/screens/settings_screen.dart';
import 'package:afrik_flow/screens/splashs/splash_screen.dart';
import 'package:afrik_flow/screens/transaction/detail_transaction.dart';
import 'package:afrik_flow/widgets/auth_base_screen.dart';
import 'package:afrik_flow/widgets/base_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/screens/home_screen.dart';
import 'package:afrik_flow/screens/send_screen.dart';
import 'package:afrik_flow/screens/transaction/transactions_screen.dart';
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
        showAppBar: false,
        title: "Envoyer de l'argent",
        child: SendScreen(),
      ),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Historiques",
        child: TransactionsScreen(),
      ),
    ),
    GoRoute(
      path: '/transaction-details',
      builder: (context, state) {
        final transactionDetails = state.extra as Transaction;
        return TransactionDetailsScreen(transaction: transactionDetails);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Mon Profile",
        child: ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/invoices',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Vos Factures",
        child: InvoiceScreen(),
      ),
    ),
    GoRoute(
      path: '/kyc',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Vérification de votre identité",
        child: KYCVerificationScreen(),
      ),
    ),
    GoRoute(
      path: '/assistance',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Assistance",
        child: AssistanceScreen(),
      ),
    ),
    GoRoute(
      path: '/all-services',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Nos Services",
        child: AllServiceScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Paramètres",
        child: SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "Aide/FAQ",
        child: HelpScreen(),
      ),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const BaseScreen(
        showAppBar: false,
        title: "À propos",
        child: AboutScreen(),
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
