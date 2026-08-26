import 'package:flutter/material.dart';

import '../../app/constants/app_breakpoints.dart';
import 'app_navbar.dart';
import 'package:go_router/go_router.dart';

class ResponsiveNav extends StatelessWidget {
  const ResponsiveNav({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

        return Column(
          children: [
            if (isMobile) const _MobileNavBar() else const AppNavigationBar(),

            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _MobileNavBar extends StatelessWidget {
  const _MobileNavBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            const _MobileBrand(),

            const Spacer(),

            Builder(
              builder: (context) {
                return IconButton(
                  tooltip: 'Open navigation menu',
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileBrand extends StatelessWidget {
  const _MobileBrand();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigation is handled by AppNavigationBar's
        // shared routing mechanism.
        context.go('/');
      },
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.home_work_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Text(
            'RENTWISE',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
