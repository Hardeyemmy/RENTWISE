import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 750) {
                    return const _MobileFooterContent();
                  }

                  return const _DesktopFooterContent();
                },
              ),

              const SizedBox(height: 48),

              Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),

              const SizedBox(height: 24),

              const _FooterBottom(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopFooterContent extends StatelessWidget {
  const _DesktopFooterContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 2, child: _FooterBrand()),

        const SizedBox(width: 60),

        const Expanded(
          child: _FooterColumn(
            title: 'Platform',
            links: [
              _FooterLink(label: 'Properties', route: '/properties'),
              _FooterLink(label: 'How it works', route: '/how-it-works'),
              _FooterLink(label: 'About us', route: '/about'),
            ],
          ),
        ),

        const Expanded(
          child: _FooterColumn(
            title: 'For Users',
            links: [
              _FooterLink(label: 'Find a Home', route: '/properties'),
              _FooterLink(label: 'Become a Landlord', route: '/register'),
              _FooterLink(label: 'Property Management', route: '/register'),
            ],
          ),
        ),

        const Expanded(
          child: _FooterColumn(
            title: 'Support',
            links: [
              _FooterLink(label: 'Contact Us', route: '/contact'),
              _FooterLink(label: 'Login', route: '/login'),
              _FooterLink(label: 'Get Started', route: '/register'),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileFooterContent extends StatelessWidget {
  const _MobileFooterContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterBrand(),

        SizedBox(height: 40),

        _FooterColumn(
          title: 'Platform',
          links: [
            _FooterLink(label: 'Properties', route: '/properties'),
            _FooterLink(label: 'How it works', route: '/how-it-works'),
            _FooterLink(label: 'About us', route: '/about'),
          ],
        ),

        SizedBox(height: 32),

        _FooterColumn(
          title: 'For Users',
          links: [
            _FooterLink(label: 'Find a Home', route: '/properties'),
            _FooterLink(label: 'Become a Landlord', route: '/register'),
            _FooterLink(label: 'Property Management', route: '/register'),
          ],
        ),

        SizedBox(height: 32),

        _FooterColumn(
          title: 'Support',
          links: [
            _FooterLink(label: 'Contact Us', route: '/contact'),
            _FooterLink(label: 'Login', route: '/login'),
            _FooterLink(label: 'Get Started', route: '/register'),
          ],
        ),
      ],
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.go('/'),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home_work_rounded,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                'RENTWISE',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'A smarter way to discover, rent, and manage properties.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            _SocialButton(icon: Icons.facebook_rounded, onTap: () {}),
            const SizedBox(width: 10),
            _SocialButton(icon: Icons.alternate_email_rounded, onTap: () {}),
            const SizedBox(width: 10),
            _SocialButton(icon: Icons.phone_rounded, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => context.go(link.route),
              child: Text(
                link.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.62),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class _FooterBottom extends StatelessWidget {
  const _FooterBottom();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '© 2026 RentWise. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 12),
              const _LegalLinks(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Text(
                '© 2026 RentWise. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ),
            const _LegalLinks(),
          ],
        );
      },
    );
  }
}

class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
        Text(
          'Terms of Service',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _FooterLink {
  const _FooterLink({required this.label, required this.route});

  final String label;
  final String route;
}
