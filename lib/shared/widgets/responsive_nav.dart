import 'package:flutter/material.dart';
import 'app_navbar.dart';

class ResponsiveNav extends StatelessWidget {
  const ResponsiveNav({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Column(
          children: [
            isMobile ? const _MobileNavBar() : const AppNavigationBar(),

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
    return AppBar(
      title: const Text('RENTWISE'),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }
}
