import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

class MobileNavigationDrawer extends StatelessWidget {
  const MobileNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Drawer(
      width: 320,
      child: SafeArea(
        child: Column(
          children: [
            const _DrawerHeader(),

            const Divider(height: 1),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    route: '/',
                    currentLocation: currentLocation,
                  ),
                  _DrawerItem(
                    icon: Icons.apartment_outlined,
                    label: 'Properties',
                    route: '/properties',
                    currentLocation: currentLocation,
                  ),
                  _DrawerItem(
                    icon: Icons.auto_awesome_outlined,
                    label: 'How it works',
                    route: '/how-it-works',
                    currentLocation: currentLocation,
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    route: '/about',
                    currentLocation: currentLocation,
                  ),
                  _DrawerItem(
                    icon: Icons.mail_outline_rounded,
                    label: 'Contact',
                    route: '/contact',
                    currentLocation: currentLocation,
                  ),
                ],
              ),
            ),

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

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
      child: Row(
        children: [
          Icon(
            Icons.home_work_rounded,
            size: 30,
            color: AppColors.primaryColor,
          ),

          const SizedBox(width: 10),

          Text(
            'RENTWISE',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),

          const Spacer(),

          IconButton(
            tooltip: 'Close navigation menu',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentLocation,
  });

  final IconData icon;
  final String label;
  final String route;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final isActive = currentLocation == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        selected: isActive,
        selectedTileColor: AppColors.primaryColor.withValues(alpha: 0.08),
        selectedColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: isActive
            ? const Icon(Icons.chevron_right_rounded, size: 20)
            : null,
        onTap: () {
          Navigator.pop(context);
          context.go(route);
        },
      ),
    );
  }
}
