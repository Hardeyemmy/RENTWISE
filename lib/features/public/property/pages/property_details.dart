import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_breakpoints.dart';
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
      color: const Color(0xFFF8FAFC),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

          return SingleChildScrollView(
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
                        onImageChanged: (index) {
                          setState(() {
                            _selectedImage = index;
                          });
                        },
                        onFavoriteChanged: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      )
                    else
                      _DesktopLayout(
                        property: property,
                        selectedImage: _selectedImage,
                        isFavorite: _isFavorite,
                        onImageChanged: (index) {
                          setState(() {
                            _selectedImage = index;
                          });
                        },
                        onFavoriteChanged: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
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
}

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
            Expanded(flex: 7, child: _PropertyInformation(property: property)),

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

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 8,
            child: _PropertyImage(
              imageUrl: images[selectedImage],
              title: property.title,
              iconSize: 80,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final selected = index == selectedImage;

              return GestureDetector(
                onTap: () => onImageChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF2563EB)
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
    if (property.imageUrl.isNotEmpty) {
      return [
        property.imageUrl,
        property.imageUrl,
        property.imageUrl,
        property.imageUrl,
      ];
    }

    return ['', '', '', ''];
  }
}

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
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
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
            color: const Color(0xFF64748B),
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

class _PropertyInformation extends StatelessWidget {
  const _PropertyInformation({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (property.isFeatured)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Featured',
                  style: TextStyle(
                    color: Color(0xFF166534),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          property.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${property.location}, ${property.city}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF64748B)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          _formatPrice(property.price),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2563EB),
          ),
        ),

        const SizedBox(height: 4),

        const Text('per year', style: TextStyle(color: Color(0xFF64748B))),

        const SizedBox(height: 28),

        _PropertySpecs(property: property),

        const SizedBox(height: 32),

        const _SectionTitle(title: 'About this property'),

        const SizedBox(height: 12),

        Text(
          'This beautiful ${property.typeLabel.toLowerCase()} '
          'offers comfortable and modern living in '
          '${property.location}, ${property.city}. '
          'The property provides a thoughtfully designed '
          'space suitable for individuals and families '
          'looking for a quality rental home.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.7,
            color: const Color(0xFF475569),
          ),
        ),

        const SizedBox(height: 32),

        const _SectionTitle(title: 'Amenities'),

        const SizedBox(height: 16),

        const _AmenitiesGrid(),
      ],
    );
  }

  static String _formatPrice(double price) {
    return '₦${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}';
  }
}

class _PropertySpecs extends StatelessWidget {
  const _PropertySpecs({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Wrap(
        spacing: 28,
        runSpacing: 18,
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
            label: property.typeLabel,
            description: 'Property type',
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
        Icon(icon, color: const Color(0xFF2563EB), size: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ],
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid();

  @override
  Widget build(BuildContext context) {
    const amenities = [
      (Icons.local_parking_outlined, 'Parking'),
      (Icons.security_outlined, 'Security'),
      (Icons.water_drop_outlined, 'Water Supply'),
      (Icons.electric_bolt_outlined, 'Electricity'),
      (Icons.wifi_rounded, 'Internet Ready'),
      (Icons.kitchen_outlined, 'Modern Kitchen'),
    ];

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
              Icon(amenity.$1, size: 20, color: const Color(0xFF2563EB)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  amenity.$2,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

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
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                child: Icon(Icons.person_outline_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Agent',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'RentWise Verified',
                      style: TextStyle(color: Color(0xFF16A34A), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Contact functionality will be connected to the backend soon.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Contact Agent'),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Schedule Viewing'),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Save this property',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Remove from favorites' : 'Save property',
                onPressed: onFavoriteChanged,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF64748B),
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
}

class _PropertyNotFound extends StatelessWidget {
  const _PropertyNotFound();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
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
            'The property you are looking for may have been removed.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B)),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0F172A),
      ),
    );
  }
}
