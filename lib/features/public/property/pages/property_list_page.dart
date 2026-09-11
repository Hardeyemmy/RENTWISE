import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/constants/app_breakpoints.dart';
import '../models/property.dart';
import '../providers/property_filter_provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/property_filter_panel.dart';

class PropertyListPage extends ConsumerWidget {
  const PropertyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(filteredPropertiesProvider);
    final filters = ref.watch(propertyFilterProvider);

    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),

              const SizedBox(height: 36),

              _SearchAndFilterBar(
                searchQuery: filters.searchQuery,
                selectedType: filters.type,
                onSearchChanged: (value) {
                  ref
                      .read(propertyFilterProvider.notifier)
                      .setSearchQuery(value);
                },
                onTypeChanged: (value) {
                  ref.read(propertyFilterProvider.notifier).setType(value);
                },
              ),

              const SizedBox(height: 20),

              PropertyFilterPanel(
                onApplied: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 28),

              _ResultsHeader(
                count: properties.length,
                sortBy: filters.sortBy,
                onSortChanged: (value) {
                  ref.read(propertyFilterProvider.notifier).setSort(value);
                },
                onClearFilters: filters.hasActiveFilters
                    ? () {
                        ref
                            .read(propertyFilterProvider.notifier)
                            .clearFilters();
                      }
                    : null,
              ),

              const SizedBox(height: 20),

              if (properties.isEmpty)
                const _EmptyState()
              else
                _PropertyGrid(properties: properties),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find your next home',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Explore quality rental properties in locations that work for you.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar({
    required this.searchQuery,
    required this.selectedType,
    required this.onSearchChanged,
    required this.onTypeChanged,
  });

  final String searchQuery;
  final PropertyType? selectedType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<PropertyType?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

        if (isMobile) {
          return Column(
            children: [
              _SearchField(value: searchQuery, onChanged: onSearchChanged),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _FilterButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _SortButton()),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: _SearchField(
                value: searchQuery,
                onChanged: onSearchChanged,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: _PropertyTypeDropdown(
                value: selectedType,
                onChanged: onTypeChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by location or property name',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: widget.value.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }
}

class _PropertyTypeDropdown extends StatelessWidget {
  const _PropertyTypeDropdown({required this.value, required this.onChanged});

  final PropertyType? value;
  final ValueChanged<PropertyType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PropertyType?>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Property type',
        prefixIcon: const Icon(Icons.home_work_outlined),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
      items: [
        const DropdownMenuItem<PropertyType?>(
          value: null,
          child: Text('All properties'),
        ),
        ...PropertyType.values.map(
          (type) => DropdownMenuItem<PropertyType?>(
            value: type,
            child: Text(_propertyTypeLabel(type)),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  static String _propertyTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return 'Apartment';

      case PropertyType.house:
        return 'House';

      case PropertyType.duplex:
        return 'Duplex';

      case PropertyType.studio:
        return 'Studio';

      case PropertyType.office:
        return 'Office';
    }
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.sortBy,
    required this.onSortChanged,
    this.onClearFilters,
  });

  final int count;
  final PropertySort sortBy;
  final ValueChanged<PropertySort> onSortChanged;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);

        final resultText = count == 1
            ? '1 property found'
            : '$count properties found';

        final sortButton = PopupMenuButton<PropertySort>(
          tooltip: 'Sort properties',
          initialValue: sortBy,
          onSelected: onSortChanged,
          itemBuilder: (context) => const [
            PopupMenuItem(value: PropertySort.newest, child: Text('Newest')),
            PopupMenuItem(
              value: PropertySort.priceLowToHigh,
              child: Text('Price: Low to High'),
            ),
            PopupMenuItem(
              value: PropertySort.priceHighToLow,
              child: Text('Price: High to Low'),
            ),
            PopupMenuItem(
              value: PropertySort.bedrooms,
              child: Text('Most Bedrooms'),
            ),
          ],
          child: OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.sort_rounded, size: 19),
            label: Text(_sortLabel(sortBy)),
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    resultText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (onClearFilters != null)
                    TextButton(
                      onPressed: onClearFilters,
                      child: const Text('Clear'),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(width: double.infinity, child: sortButton),
            ],
          );
        }

        return Row(
          children: [
            Text(
              resultText,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const Spacer(),

            if (onClearFilters != null)
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear filters'),
              ),

            const SizedBox(width: 8),

            sortButton,
          ],
        );
      },
    );
  }

  static String _sortLabel(PropertySort sort) {
    switch (sort) {
      case PropertySort.newest:
        return 'Newest';

      case PropertySort.priceLowToHigh:
        return 'Price: Low to High';

      case PropertySort.priceHighToLow:
        return 'Price: High to Low';

      case PropertySort.bedrooms:
        return 'Most Bedrooms';
    }
  }
}

class _PropertyGrid extends StatelessWidget {
  const _PropertyGrid({required this.properties});

  final List<Property> properties;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (constraints.maxWidth < 600) {
          columns = 1;
        } else if (constraints.maxWidth < 950) {
          columns = 2;
        } else {
          columns = 3;
        }

        const spacing = 24.0;

        final cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: properties.map((property) {
            return SizedBox(
              width: cardWidth,
              child: PropertyCard(property: property),
            );
          }).toList(),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 36,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'No properties found',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          Text(
            'Try adjusting your search or filters to find more properties.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(propertyFilterProvider);

    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const _MobileFilterSheet();
          },
        );
      },
      icon: const Icon(Icons.tune_rounded),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Filters'),

          if (filters.hasActiveFilters) ...[
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(propertyFilterProvider);

    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            return _SortSheet(currentSort: filters.sortBy);
          },
        );
      },
      icon: const Icon(Icons.swap_vert_rounded),
      label: const Text('Sort'),
    );
  }
}

class _MobileFilterSheet extends StatelessWidget {
  const _MobileFilterSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Row(
                  children: [
                    Text(
                      'Filter properties',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: const PropertyFilterPanel(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SortSheet extends ConsumerWidget {
  const _SortSheet({required this.currentSort});

  final PropertySort currentSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort properties',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            _sortOption(
              context,
              ref,
              PropertySort.newest,
              'Newest',
              Icons.new_releases_outlined,
            ),

            _sortOption(
              context,
              ref,
              PropertySort.priceLowToHigh,
              'Price: Low to High',
              Icons.arrow_upward_rounded,
            ),

            _sortOption(
              context,
              ref,
              PropertySort.priceHighToLow,
              'Price: High to Low',
              Icons.arrow_downward_rounded,
            ),

            _sortOption(
              context,
              ref,
              PropertySort.bedrooms,
              'Most Bedrooms',
              Icons.bed_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(
    BuildContext context,
    WidgetRef ref,
    PropertySort value,
    String label,
    IconData icon,
  ) {
    final selected = currentSort == value;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB))
          : null,
      onTap: () {
        ref.read(propertyFilterProvider.notifier).setSort(value);

        Navigator.pop(context);
      },
    );
  }
}
