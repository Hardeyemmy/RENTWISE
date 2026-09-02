import 'package:flutter/material.dart';

import '../../../../app/constants/app_breakpoints.dart';
import '../data/mock_property.dart';
import '../widgets/property_card.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  String searchQuery = '';
  String selectedType = 'All';

  List get filteredProperties {
    return MockProperty.properties.where((property) {
      final query = searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          property.title.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query) ||
          property.city.toLowerCase().contains(query);

      final matchesType =
          selectedType == 'All' || property.typeLabel == selectedType;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(),

                const SizedBox(height: 36),

                _SearchAndFilterBar(
                  searchQuery: searchQuery,
                  selectedType: selectedType,
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onTypeChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),

                const SizedBox(height: 36),

                _ResultsHeader(count: filteredProperties.length),

                const SizedBox(height: 20),

                _PropertyGrid(properties: filteredProperties),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find your next home',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
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
  final String selectedType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onTypeChanged;

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
              _PropertyTypeDropdown(
                value: selectedType,
                onChanged: onTypeChanged,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search by location or property name',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: value.isNotEmpty
            ? IconButton(
                onPressed: () {
                  // The parent will handle clearing
                  // when this becomes a controller-driven field.
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
    );
  }
}

class _PropertyTypeDropdown extends StatelessWidget {
  const _PropertyTypeDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const types = ['All', 'Apartment', 'House', 'Duplex', 'Studio'];

    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Property type',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      items: types
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count properties found',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.sort_rounded, size: 19),
          label: const Text('Sort'),
        ),
      ],
    );
  }
}

class _PropertyGrid extends StatelessWidget {
  const _PropertyGrid({required this.properties});

  final List properties;

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

        final spacing = 24.0;
        final cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: properties.map<Widget>((property) {
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
