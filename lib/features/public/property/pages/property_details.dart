import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_breakpoints.dart';
import '../../../../app/theme/app_colors.dart';
import '../models/property.dart';
import '../providers/property_provider.dart';

class PropertyDetailsPage extends ConsumerWidget {
  const PropertyDetailsPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(propertyListProvider);

    Property? property;

    for (final item in properties) {
      if (item.id == propertyId) {
        property = item;
        break;
      }
    }

    if (property == null) {
      return const _PropertyNotFound();
    }

    return _PropertyDetailsView(property: property);
  }
}

class _PropertyDetailsView extends StatefulWidget {
  const _PropertyDetailsView({required this.property});

  final Property property;

  @override
  State<_PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<_PropertyDetailsView> {
  int _selectedImage = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Container(
      color: AppColors.backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 24 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BackButton(),

                    const SizedBox(height: 24),

                    if (isMobile)
                      _MobileLayout(
                        property: property,
                        selectedImage: _selectedImage,
                        isFavorite: _isFavorite,
                        onImageChanged: _changeImage,
                        onFavoriteChanged: _toggleFavorite,
                      )
                    else
                      _DesktopLayout(
                        property: property,
                        selectedImage: _selectedImage,
                        isFavorite: _isFavorite,
                        onImageChanged: _changeImage,
                        onFavoriteChanged: _toggleFavorite,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _changeImage(int index) {
    setState(() {
      _selectedImage = index;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }
}

// -----------------------------------------------------------------------------
// BACK BUTTON
// -----------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/properties');
        }
      },
      icon: const Icon(Icons.arrow_back_rounded),
      label: const Text('Back to properties'),
    );
  }
}

// -----------------------------------------------------------------------------
// DESKTOP LAYOUT
// -----------------------------------------------------------------------------

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.property,
    required this.selectedImage,
    required this.isFavorite,
    required this.onImageChanged,
    required this.onFavoriteChanged,
  });

  final Property property;
  final int selectedImage;
  final bool isFavorite;
  final ValueChanged<int> onImageChanged;
  final VoidCallback onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PropertyGallery(
          property: property,
          selectedImage: selectedImage,
          onImageChanged: onImageChanged,
        ),

        const SizedBox(height: 32),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _PropertyInformation(property: property)),

            const SizedBox(width: 32),

            SizedBox(
              width: 340,
              child: _ContactCard(
                property: property,
                isFavorite: isFavorite,
                onFavoriteChanged: onFavoriteChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// MOBILE LAYOUT
// -----------------------------------------------------------------------------

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.property,
    required this.selectedImage,
    required this.isFavorite,
    required this.onImageChanged,
    required this.onFavoriteChanged,
  });

  final Property property;
  final int selectedImage;
  final bool isFavorite;
  final ValueChanged<int> onImageChanged;
  final VoidCallback onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PropertyGallery(
          property: property,
          selectedImage: selectedImage,
          onImageChanged: onImageChanged,
        ),

        const SizedBox(height: 24),

        _PropertyInformation(property: property),

        const SizedBox(height: 24),

        _ContactCard(
          property: property,
          isFavorite: isFavorite,
          onFavoriteChanged: onFavoriteChanged,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// PROPERTY GALLERY
// -----------------------------------------------------------------------------

class _PropertyGallery extends StatelessWidget {
  const _PropertyGallery({
    required this.property,
    required this.selectedImage,
    required this.onImageChanged,
  });

  final Property property;
  final int selectedImage;
  final ValueChanged<int> onImageChanged;

  @override
  Widget build(BuildContext context) {
    final images = _imagesFor(property);

    final safeIndex = selectedImage >= images.length ? 0 : selectedImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: _PropertyImage(
                  imageUrl: images[safeIndex],
                  title: property.title,
                  iconSize: 80,
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: _GalleryBadge(
                label: property.statusLabel,
                color: _statusColor(property.status),
              ),
            ),

            if (property.isFeatured)
              Positioned(
                top: 16,
                right: 16,
                child: _GalleryBadge(
                  label: 'Featured',
                  color: AppColors.primaryColor,
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final selected = index == safeIndex;

              return GestureDetector(
                onTap: () => onImageChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _PropertyImage(
                      imageUrl: images[index],
                      title: '',
                      iconSize: 26,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<String> _imagesFor(Property property) {
    if (property.images.isEmpty) {
      return const ['', '', '', ''];
    }

    return property.images
            .where((image) => image.trim().isNotEmpty)
            .toList()
            .isEmpty
        ? const ['', '', '', '']
        : property.images.where((image) => image.trim().isNotEmpty).toList();
  }

  Color _statusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.available:
        return AppColors.success;
      case PropertyStatus.rented:
        return AppColors.warning;
      case PropertyStatus.sold:
        return AppColors.error;
      case PropertyStatus.pending:
        return AppColors.warning;
    }
  }
}

class _GalleryBadge extends StatelessWidget {
  const _GalleryBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PROPERTY IMAGE
// -----------------------------------------------------------------------------

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({
    required this.imageUrl,
    required this.title,
    required this.iconSize,
  });

  final String imageUrl;
  final String title;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) {
          return _PlaceholderImage(title: title, iconSize: iconSize);
        },
      );
    }

    return _PlaceholderImage(title: title, iconSize: iconSize);
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({required this.title, required this.iconSize});

  final String title;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_rounded,
            size: iconSize,
            color: AppColors.textSecondary,
          ),

          if (title.isNotEmpty) ...[
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PROPERTY INFORMATION
// -----------------------------------------------------------------------------

class _PropertyInformation extends StatelessWidget {
  const _PropertyInformation({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PropertyBadges(property: property),

        const SizedBox(height: 14),

        Text(
          property.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        _LocationRow(property: property),

        const SizedBox(height: 20),

        _PriceSection(property: property),

        const SizedBox(height: 28),

        _PropertySpecs(property: property),

        const SizedBox(height: 32),

        const _SectionTitle(title: 'About this property'),

        const SizedBox(height: 12),

        Text(
          property.description.trim().isEmpty
              ? 'No description is available for this property.'
              : property.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.7,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 32),

        if (property.amenities.isNotEmpty) ...[
          const _SectionTitle(title: 'Amenities'),

          const SizedBox(height: 16),

          _AmenitiesGrid(amenities: property.amenities),

          const SizedBox(height: 32),
        ],

        _AdditionalDetails(property: property),
      ],
    );
  }
}

class _PropertyBadges extends StatelessWidget {
  const _PropertyBadges({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoBadge(label: property.propertyTypeLabel),
        _InfoBadge(label: property.listingTypeLabel, highlighted: true),
        _InfoBadge(
          label: property.statusLabel,
          success: property.status == PropertyStatus.available,
        ),
      ],
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.label,
    this.highlighted = false,
    this.success = false,
  });

  final String label;
  final bool highlighted;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final background = success
        ? const Color(0xFFDCFCE7)
        : highlighted
        ? const Color(0xFFEFF6FF)
        : const Color(0xFFF1F5F9);

    final foreground = success
        ? const Color(0xFF166534)
        : highlighted
        ? AppColors.primaryColor
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final location =
        property.address != null && property.address!.trim().isNotEmpty
        ? property.address!
        : '${property.location}, ${property.city}, ${property.state}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 20,
          color: AppColors.textSecondary,
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            location,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatPrice(property.price),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),

        if (property.listingType == ListingType.rent) ...[
          const SizedBox(width: 6),

          const Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Text(
              '/ year',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }

  String _formatPrice(double price) {
    return '₦${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}';
  }
}

// -----------------------------------------------------------------------------
// PROPERTY SPECS
// -----------------------------------------------------------------------------

class _PropertySpecs extends StatelessWidget {
  const _PropertySpecs({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Wrap(
        spacing: 28,
        runSpacing: 20,
        children: [
          _SpecItem(
            icon: Icons.bed_outlined,
            label: '${property.bedrooms}',
            description: 'Bedrooms',
          ),

          _SpecItem(
            icon: Icons.bathtub_outlined,
            label: '${property.bathrooms}',
            description: 'Bathrooms',
          ),

          _SpecItem(
            icon: Icons.square_foot_rounded,
            label: '${property.area.toStringAsFixed(0)} m²',
            description: 'Floor area',
          ),

          _SpecItem(
            icon: Icons.home_work_outlined,
            label: property.propertyTypeLabel,
            description: 'Property type',
          ),

          if (property.parkingSpaces != null)
            _SpecItem(
              icon: Icons.local_parking_outlined,
              label: '${property.parkingSpaces}',
              description: 'Parking',
            ),

          if (property.yearBuilt != null)
            _SpecItem(
              icon: Icons.calendar_today_outlined,
              label: '${property.yearBuilt}',
              description: 'Year built',
            ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),

            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// AMENITIES
// -----------------------------------------------------------------------------

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amenities.map((amenity) {
        return Container(
          width: 180,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Icon(
                _amenityIcon(amenity),
                size: 20,
                color: AppColors.primaryColor,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  amenity,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _amenityIcon(String amenity) {
    final value = amenity.toLowerCase();

    if (value.contains('parking')) {
      return Icons.local_parking_outlined;
    }

    if (value.contains('security')) {
      return Icons.security_outlined;
    }

    if (value.contains('water')) {
      return Icons.water_drop_outlined;
    }

    if (value.contains('electric')) {
      return Icons.electric_bolt_outlined;
    }

    if (value.contains('internet') || value.contains('wifi')) {
      return Icons.wifi_rounded;
    }

    if (value.contains('kitchen')) {
      return Icons.kitchen_outlined;
    }

    if (value.contains('pool')) {
      return Icons.pool_outlined;
    }

    if (value.contains('gym')) {
      return Icons.fitness_center_outlined;
    }

    if (value.contains('air')) {
      return Icons.ac_unit_outlined;
    }

    if (value.contains('garden')) {
      return Icons.yard_outlined;
    }

    return Icons.check_circle_outline_rounded;
  }
}

// -----------------------------------------------------------------------------
// ADDITIONAL DETAILS
// -----------------------------------------------------------------------------

class _AdditionalDetails extends StatelessWidget {
  const _AdditionalDetails({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Property details'),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Column(
            children: [
              _DetailRow(label: 'Property ID', value: property.id),

              _DetailRow(
                label: 'Property type',
                value: property.propertyTypeLabel,
              ),

              _DetailRow(label: 'Listing', value: property.listingTypeLabel),

              _DetailRow(label: 'Status', value: property.statusLabel),

              _DetailRow(
                label: 'Location',
                value: '${property.location}, ${property.city}',
              ),

              _DetailRow(label: 'State', value: property.state),

              if (property.yearBuilt != null)
                _DetailRow(label: 'Year built', value: '${property.yearBuilt}'),

              if (property.parkingSpaces != null)
                _DetailRow(
                  label: 'Parking spaces',
                  value: '${property.parkingSpaces}',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CONTACT / AGENT CARD
// -----------------------------------------------------------------------------

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.property,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  final Property property;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    final agent = property.agent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AgentHeader(agent: agent),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showContactMessage(context),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Contact Agent'),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showViewingMessage(context),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Schedule Viewing'),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 12),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Save this property',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              IconButton(
                tooltip: isFavorite ? 'Remove from favorites' : 'Save property',
                onPressed: onFavoriteChanged,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Property ID: ${property.id}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  void _showContactMessage(BuildContext context) {
    final agentName = property.agent?.name ?? 'the property agent';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contacting $agentName will be connected to the backend soon.',
        ),
      ),
    );
  }

  void _showViewingMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Viewing scheduling will be connected to the backend soon.',
        ),
      ),
    );
  }
}

class _AgentHeader extends StatelessWidget {
  const _AgentHeader({required this.agent});

  final PropertyAgent? agent;

  @override
  Widget build(BuildContext context) {
    if (agent == null) {
      return const Row(
        children: [
          CircleAvatar(radius: 28, child: Icon(Icons.person_outline_rounded)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Property Agent',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage:
              agent!.photoUrl != null && agent!.photoUrl!.trim().isNotEmpty
              ? NetworkImage(agent!.photoUrl!)
              : null,
          child: agent!.photoUrl == null || agent!.photoUrl!.trim().isEmpty
              ? const Icon(Icons.person_outline_rounded)
              : null,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agent!.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  if (agent!.isVerified)
                    const Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: AppColors.success,
                    ),

                  if (agent!.isVerified) const SizedBox(width: 4),

                  Text(
                    agent!.isVerified ? 'Verified agent' : 'Property agent',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              if (agent!.phone.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  agent!.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// SECTION TITLE
// -----------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// NOT FOUND
// -----------------------------------------------------------------------------

class _PropertyNotFound extends StatelessWidget {
  const _PropertyNotFound();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.home_work_outlined,
            size: 64,
            color: Color(0xFF94A3B8),
          ),

          const SizedBox(height: 20),

          Text(
            'Property not found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          const Text(
            'The property you are looking for may have been removed or is no longer available.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () => context.go('/properties'),
            child: const Text('Browse properties'),
          ),
        ],
      ),
    );
  }
}
