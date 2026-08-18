import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'responsive_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const _MobileDrawer(),
      body: ResponsiveNav(child: child),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.home_work_rounded,
                    size: 30,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'RENTWISE',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),

            const Divider(),

            const SizedBox(height: 12),

            _DrawerItem(icon: Icons.home_outlined, label: 'Home', route: '/'),

            _DrawerItem(
              icon: Icons.apartment_outlined,
              label: 'Properties',
              route: '/properties',
            ),

            _DrawerItem(
              icon: Icons.auto_awesome_outlined,
              label: 'How it works',
              route: '/how-it-works',
            ),

            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'About',
              route: '/about',
            ),

            _DrawerItem(
              icon: Icons.mail_outline_rounded,
              label: 'Contact',
              route: '/contact',
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                      child: const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/register');
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF64748B)),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
        // We'll connect GoRouter here.
      },
    );
  }
}
