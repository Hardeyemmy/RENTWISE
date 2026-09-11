import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        onTap:
            onTap ??
            () {
              context.go('/properties/${property.id}');
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
                  // --------------------------------------------------
                  // Property title
                  // --------------------------------------------------
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // --------------------------------------------------
                  // Location
                  // --------------------------------------------------
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

                  const SizedBox(height: 12),

                  // --------------------------------------------------
                  // Property type + listing type
                  // --------------------------------------------------
                  Row(
                    children: [
                      _PropertyTag(label: property.propertyTypeLabel),
                      const SizedBox(width: 8),
                      _PropertyTag(
                        label: property.listingTypeLabel,
                        highlighted: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --------------------------------------------------
                  // Property features
                  // --------------------------------------------------
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

                  // --------------------------------------------------
                  // Price
                  // --------------------------------------------------
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
                      const SizedBox(width: 4),
                      Text(
                        _pricePeriod(property.listingType),
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

  String _pricePeriod(ListingType listingType) {
    switch (listingType) {
      case ListingType.rent:
        return '/ year';

      case ListingType.sale:
        return '';
    }
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.images.isNotEmpty ? property.images.first : null;

    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          color: AppColors.backgroundColor,
          child: imageUrl == null || imageUrl.isEmpty
              ? const _ImagePlaceholder()
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return const _ImagePlaceholder();
                  },
                ),
        ),

        // ------------------------------------------------------------
        // Featured badge
        // ------------------------------------------------------------
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

        // ------------------------------------------------------------
        // Property status
        // ------------------------------------------------------------
        Positioned(
          left: 14,
          bottom: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              property.statusLabel,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        // ------------------------------------------------------------
        // Favorite button
        // ------------------------------------------------------------
        Positioned(
          top: 12,
          right: 12,
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Save property',
              onPressed: () {
                // Favorite functionality will be connected
                // to Riverpod state later.
              },
              icon: const Icon(Icons.favorite_border_rounded, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.home_work_outlined,
        size: 56,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _PropertyTag extends StatelessWidget {
  const _PropertyTag({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primaryColor.withValues(alpha: 0.08)
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: highlighted ? AppColors.primaryColor : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
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
