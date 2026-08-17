import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const _SectionHeading(),
              const SizedBox(height: 56),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 850;

                  if (isMobile) {
                    return const _MobileSteps();
                  }
                  return const _DesktopSteps();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.accentColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'How it Works',
            style: TextStyle(
              color: AppColors.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'A Simpler way to manage renting',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            'Whether you are looking for a home, listing a property, '
            'or managing multiple rentals, RentWise keeps everything '
            'in one place.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopSteps extends StatelessWidget {
  const _DesktopSteps();

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepData(
        number: '01',
        icon: Icons.search_rounded,
        title: 'Find Your Home',
        description:
            'Browse available properties, compare your options, '
            'and find a home that matches your needs and budget.',
      ),
      _StepData(
        number: '02',
        icon: Icons.handshake_outlined,
        title: 'Connect & Rent',
        description:
            'Connect with landlords, submit your application, '
            'and move forward with your rental agreement.',
      ),
      _StepData(
        number: '03',
        icon: Icons.home_work_outlined,
        title: 'Manage Everything',
        description:
            'Keep track of rent, maintenance requests, tenancy '
            'information, and other important rental activities.',
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(child: _StepItem(step: steps[i])),
          if (i != steps.length - 1) const _Connector(),
        ],
      ],
    );
  }
}

class _MobileSteps extends StatelessWidget {
  const _MobileSteps();

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepData(
        number: '01',
        icon: Icons.search_rounded,
        title: 'Find Your Home',
        description:
            'Browse available properties, compare your options, '
            'and find a home that matches your needs and budget.',
      ),
      _StepData(
        number: '02',
        icon: Icons.handshake_outlined,
        title: 'Connect & Rent',
        description:
            'Connect with landlords, submit your application, '
            'and move forward with your rental agreement.',
      ),
      _StepData(
        number: '03',
        icon: Icons.home_work_outlined,
        title: 'Manage Everything',
        description:
            'Keep track of rent, maintenance requests, tenancy '
            'information, and other important rental activities.',
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _StepItem(step: steps[i]),
          if (i != steps.length - 1) const _MobileConnector(),
        ],
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step});

  final _StepData step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(step.icon, size: 34, color: AppColors.primaryColor),
            ),

            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  step.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Text(
          step.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          step.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, left: 16, right: 16),
      child: SizedBox(
        width: 70,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.primaryColor.withValues(alpha: 0.20),
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileConnector extends StatelessWidget {
  const _MobileConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.primaryColor.withValues(alpha: 0.20),
    );
  }
}

class _StepData {
  const _StepData({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
}
