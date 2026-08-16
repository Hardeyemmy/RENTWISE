import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const testimonials = [
      _TestimonialData(
        name: 'Amaka Johnson',
        role: 'Tenant',
        location: 'Lagos, Nigeria',
        initials: 'AJ',
        rating: 5,
        review:
            'RentWise made finding my apartment much easier. '
            'I could compare properties and communicate with the landlord '
            'without jumping between different platforms.',
      ),
      _TestimonialData(
        name: 'David Adekunle',
        role: 'Property Owner',
        location: 'Abuja, Nigeria',
        initials: 'DA',
        rating: 5,
        review:
            'Managing my rental properties has become much more organized. '
            'RentWise gives me a simple way to keep track of tenants, '
            'properties, and rental activities.',
      ),
      _TestimonialData(
        name: 'Sarah Williams',
        role: 'Property Manager',
        location: 'Lagos, Nigeria',
        initials: 'SW',
        rating: 5,
        review:
            'The platform gives our team a better overview of our properties '
            'and maintenance requests. It has made our day-to-day operations '
            'much easier to manage.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const _TestimonialsHeader(),

              const SizedBox(height: 52),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 750) {
                    return Column(
                      children: [
                        for (int i = 0; i < testimonials.length; i++) ...[
                          _TestimonialCard(testimonial: testimonials[i]),
                          if (i != testimonials.length - 1)
                            const SizedBox(height: 20),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < testimonials.length; i++) ...[
                        Expanded(
                          child: _TestimonialCard(testimonial: testimonials[i]),
                        ),
                        if (i != testimonials.length - 1)
                          const SizedBox(width: 24),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialsHeader extends StatelessWidget {
  const _TestimonialsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'WHAT PEOPLE SAY',
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
          'Built around the people who use it.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 14),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            'A better rental experience starts with a platform that '
            'works for everyone involved.',
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

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.testimonial});

  final _TestimonialData testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              testimonial.rating,
              (index) => const Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(
                  Icons.star_rounded,
                  size: 19,
                  color: AppColors.warning,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '"${testimonial.review}"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          const Divider(height: 1),

          const SizedBox(height: 22),

          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  testimonial.initials,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${testimonial.role} • ${testimonial.location}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestimonialData {
  const _TestimonialData({
    required this.name,
    required this.role,
    required this.location,
    required this.initials,
    required this.rating,
    required this.review,
  });

  final String name;
  final String role;
  final String location;
  final String initials;
  final int rating;
  final String review;
}
