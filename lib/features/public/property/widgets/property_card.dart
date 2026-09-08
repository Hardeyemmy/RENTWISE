import 'package:flutter/material.dart';
import '../pages/property_details.dart';
import '../../../../app/theme/app_colors.dart';
import '../models/property.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  PropertyDetailsPage(propertyId: property.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PropertyImage(property: property),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.location}, ${property.city}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _PropertyFeature(
                        icon: Icons.bed_outlined,
                        label: '${property.bedrooms} Beds',
                      ),
                      const SizedBox(width: 14),
                      _PropertyFeature(
                        icon: Icons.bathtub_outlined,
                        label: '${property.bathrooms} Baths',
                      ),
                      const SizedBox(width: 14),
                      _PropertyFeature(
                        icon: Icons.square_foot_outlined,
                        label: '${property.area.toInt()} m²',
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Text(
                        _formatPrice(property.price),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '/ year',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '₦${(price / 1000000).toStringAsFixed(1)}M';
    }

    if (price >= 1000) {
      return '₦${(price / 1000).toStringAsFixed(0)}K';
    }

    return '₦${price.toStringAsFixed(0)}';
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          color: AppColors.backgroundColor,
          child: property.imageUrl.isEmpty
              ? const Center(
                  child: Icon(
                    Icons.home_work_outlined,
                    size: 56,
                    color: AppColors.textSecondary,
                  ),
                )
              : Image.network(
                  property.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 48),
                    );
                  },
                ),
        ),

        if (property.isFeatured)
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Featured',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

        Positioned(
          top: 12,
          right: 12,
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Save property',
              onPressed: () {},
              icon: const Icon(Icons.favorite_border_rounded, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _PropertyFeature extends StatelessWidget {
  const _PropertyFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
