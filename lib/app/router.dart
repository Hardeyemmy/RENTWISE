import 'package:go_router/go_router.dart';

import '../features/public/home/pages/home_page.dart';
import '../features/public/about/pages/about_pages.dart';
import '../features/public/contact/pages/contact_page.dart';
import '../features/public/property/pages/property_list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
    GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
    GoRoute(
      path: '/properties',
      builder: (context, state) => const PropertyListPage(),
    ),
  ],
);
