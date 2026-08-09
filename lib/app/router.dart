import 'package:go_router/go_router.dart';
import '../shared/widgets/app_shell.dart';
import '../features/public/home/pages/home_page.dart';
import '../features/public/home/pages/login.dart';
import '../features/public/home/pages/register.dart';
import '../features/public/about/pages/about_pages.dart';
import '../features/public/contact/pages/contact_page.dart';
import '../features/public/home/pages/how_it_works.dart';
import '../features/public/property/pages/property_list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactPage(),
        ),
        GoRoute(
          path: '/properties',
          builder: (context, state) => const PropertyListPage(),
        ),

        GoRoute(
          path: '/how-it-works',
          builder: (context, state) => const HowItWorks(),
        ),

        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

        GoRoute(
          path: '/register',
          builder: (context, state) => const Register(),
        ),
      ],
    ),
  ],
);
