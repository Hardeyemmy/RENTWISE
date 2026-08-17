import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      color: AppColors.backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 64),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                if (isMobile) {
                  return _MobileCtaContent();
                }
                return _DesktopCtaContent();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopCtaContent extends StatelessWidget {
  const _DesktopCtaContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _CtaText()),
        const SizedBox(width: 50),

        _CtaButtons(),
      ],
    );
  }
}

class _MobileCtaContent extends StatelessWidget {
  const _MobileCtaContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_CtaText(), const SizedBox(height: 30), _CtaButtons()],
    );
  }
}

class _CtaText extends StatelessWidget {
  const _CtaText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to find your next home?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'Join RentWise and experience a simpler, smarter way to rent, '
          'manage, and discover properties.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _CtaButtons extends StatelessWidget {
  const _CtaButtons();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton(
          onPressed: () => context.go('/properties'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          ),
          child: const Text('Browse Properties'),
        ),
        OutlinedButton(
          onPressed: () => context.go('/register'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          ),
          child: const Text('Get Started'),
        ),
      ],
    );
  }
}
