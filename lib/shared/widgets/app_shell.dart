import 'package:flutter/material.dart';

import 'mobile_navigation_drawer.dart';
import 'responsive_nav.dart';
import 'app_footer.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MobileNavigationDrawer(),
      body: ResponsiveNav(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: child),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}
