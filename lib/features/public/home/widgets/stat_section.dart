import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class StatSection extends StatelessWidget {
  const StatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceColor,
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;

              final stats = [
                const _StatItem(
                  value: '10k+',
                  label: 'Properties Listed',
                  icon: Icons.home_work_outlined,
                ),
                const _StatItem(
                  value: '5K+',
                  label: 'Happy Tenants',
                  icon: Icons.people_outline_rounded,
                ),
                const _StatItem(
                  value: '2K+',
                  label: 'Trusted Landlords',
                  icon: Icons.business_outlined,
                ),
                const _StatItem(
                  value: '98%',
                  label: 'Customer Satisfaction',
                  icon: Icons.star_outline_rounded,
                ),
              ];

              if (isDesktop) {
                return Row(
                  children: [
                    for (int i = 0; i < stats.length; i++) ...[
                      Expanded(child: stats[i]),
                      if (i != stats.length - 1)
                        Container(
                          height: 64,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  for (int i = 0; i < stats.length; i++) ...[
                    stats[i],
                    if (i != stats.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 23),
        ),

        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
