import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import 'property_card.dart';

class FeaturedPropertySection extends StatelessWidget {
  const FeaturedPropertySection({super.key});

  @override
  Widget build(BuildContext context) {
    const properties = [
      _PropertyData(
        title: 'Modern 3 Bedroom Apartment',
        location: 'Lekki Phase 1, Lagos',
        price: '₦2.5M / year',
        bedrooms: 3,
        bathrooms: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1000&q=80',
      ),
      _PropertyData(
        title: 'Contemporary 2 Bedroom Flat',
        location: 'Ikeja GRA, Lagos',
        price: '₦1.8M / year',
        bedrooms: 2,
        bathrooms: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=1000&q=80',
      ),
      _PropertyData(
        title: 'Luxury 4 Bedroom Residence',
        location: 'Victoria Island, Lagos',
        price: '₦3.2M / year',
        bedrooms: 4,
        bathrooms: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1000&q=80',
      ),
    ];
    return Container(
      width: double.infinity,
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(onViewAll: () => context.go('/properties')),
              const SizedBox(height: 36),
              LayoutBuilder(
                builder: ((context, constraints) {
                  final width = constraints.maxWidth;

                  if (width < 700) {
                    return Column(
                      children: [
                        for (final property in properties) ...[
                          PropertyCard(
                            title: property.title,
                            location: property.location,
                            price: property.price,
                            imageUrl: property.imageUrl,
                            bedrooms: property.bedrooms,
                            bathrooms: property.bathrooms,
                            onTap: () => context.go('/properties'),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < properties.length; i++) ...[
                        Expanded(
                          child: PropertyCard(
                            title: properties[i].title,
                            location: properties[i].location,
                            price: properties[i].price,
                            imageUrl: properties[i].imageUrl,
                            bedrooms: properties[i].bedrooms,
                            bathrooms: properties[i].bathrooms,
                            onTap: () => context.go('/properties'),
                          ),
                        ),
                        if (i != properties.length - 1)
                          const SizedBox(width: 24),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(context),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: onViewAll,
                child: const Text('View all Properties'),
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _title(context)),
            OutlinedButton(
              onPressed: onViewAll,
              child: const Text('View all Properties'),
            ),
          ],
        );
      },
    );
  }
}

Widget _title(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Featured Properties',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Explore some of the best rental Properties available on RENTWISE',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    ],
  );
}

class _PropertyData {
  const _PropertyData({
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.imageUrl,
  });

  final String title;
  final String location;
  final String price;
  final int bedrooms;
  final int bathrooms;
  final String imageUrl;
}
