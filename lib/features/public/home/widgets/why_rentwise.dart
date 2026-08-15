import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class WhyRentWiseSection extends StatelessWidget {
  const WhyRentWiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 850;

              if (isMobile) {
                return const _MobileLayout();
              }

              return const _DesktopLayout();
            },
          ),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _SectionIntro()),
        const SizedBox(width: 80),
        Expanded(flex: 7, child: _FeatureGrid()),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionIntro(),
        const SizedBox(height: 48),
        const _FeatureGrid(),
      ],
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'WHY RENTWISE',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Everything you need to rent with confidence.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'RentWise brings tenants, landlords, and property managers '
          'together in one simple platform designed to make renting '
          'easier, safer, and more transparent.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const features = [
    _FeatureData(
      icon: Icons.search_rounded,
      title: 'Find the Right Property',
      description:
          'Search and discover properties based on location, budget, '
          'property type, and your specific needs.',
    ),
    _FeatureData(
      icon: Icons.verified_user_outlined,
      title: 'Trusted Listings',
      description:
          'Discover quality properties and connect with landlords '
          'through a more transparent rental experience.',
    ),
    _FeatureData(
      icon: Icons.payments_outlined,
      title: 'Simplified Payments',
      description:
          'Keep rent and other rental payments organized through '
          'a convenient digital experience.',
    ),
    _FeatureData(
      icon: Icons.build_outlined,
      title: 'Easy Maintenance',
      description:
          'Tenants can report maintenance issues while property '
          'managers keep track of requests and resolutions.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;

        if (isSmall) {
          return Column(
            children: [
              for (int i = 0; i < features.length; i++) ...[
                _FeatureCard(feature: features[i]),
                if (i != features.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            return _FeatureCard(feature: features[index]);
          },
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _FeatureData feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(feature.icon, color: AppColors.primaryColor, size: 24),
          ),

          const SizedBox(height: 20),

          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
