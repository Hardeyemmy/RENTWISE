import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          const _Brand(),

          const Spacer(),

          _NavItem(label: 'Properties', onTap: () => context.go('/properties')),

          _NavItem(
            label: 'How it works',
            onTap: () => context.go('/how-it-works'),
          ),

          _NavItem(label: 'About', onTap: () => context.go('/about')),
          const SizedBox(width: 24),

          OutlinedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Login'),
          ),

          const SizedBox(width: 12),

          FilledButton(
            onPressed: () => context.go('/register'),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      child: Row(
        children: [
          Icon(
            Icons.home_work_sharp,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            'RENTWISE',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onTap, child: Text(label));
  }
}
