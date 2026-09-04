import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';
import '../providers/property_filter_provider.dart';

class PropertyFilterPanel extends ConsumerStatefulWidget {
  const PropertyFilterPanel({super.key, this.onApplied});

  final VoidCallback? onApplied;

  @override
  ConsumerState<PropertyFilterPanel> createState() =>
      _PropertyFilterPanelState();
}

class _PropertyFilterPanelState extends ConsumerState<PropertyFilterPanel> {
  late RangeValues _priceRange;

  static const double _minPrice = 500000;
  static const double _maxPrice = 10000000;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(propertyFilterProvider);

    _priceRange = RangeValues(
      filter.minPrice ?? _minPrice,
      filter.maxPrice ?? _maxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(propertyFilterProvider);
    final notifier = ref.read(propertyFilterProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, notifier),
          const SizedBox(height: 24),

          _buildLocationField(context, filters, notifier),

          const SizedBox(height: 20),

          _buildPropertyType(context, filters, notifier),

          const SizedBox(height: 28),

          _buildPriceRange(context, notifier),

          const SizedBox(height: 28),

          _buildBedrooms(context, filters, notifier),

          const SizedBox(height: 28),

          _buildActions(context, notifier),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PropertyFilterNotifier notifier) {
    return Row(
      children: [
        const Icon(Icons.tune_rounded, color: Color(0xFF2563EB)),
        const SizedBox(width: 10),
        Text(
          'Filter properties',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            notifier.clearFilters();

            setState(() {
              _priceRange = const RangeValues(_minPrice, _maxPrice);
            });
          },
          child: const Text('Clear all'),
        ),
      ],
    );
  }

  Widget _buildLocationField(
    BuildContext context,
    PropertyFilterState filters,
    PropertyFilterNotifier notifier,
  ) {
    return TextFormField(
      initialValue: filters.location,
      onChanged: notifier.setLocation,
      decoration: InputDecoration(
        labelText: 'Location',
        hintText: 'e.g. Lekki, Yaba, Abuja',
        prefixIcon: const Icon(Icons.location_on_outlined),
        suffixIcon: filters.location.isNotEmpty
            ? IconButton(
                tooltip: 'Clear location',
                onPressed: () {
                  notifier.setLocation('');
                  setState(() {});
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
    );
  }

  Widget _buildPropertyType(
    BuildContext context,
    PropertyFilterState filters,
    PropertyFilterNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property type',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _typeChip(
              label: 'All',
              selected: filters.type == null,
              onTap: () => notifier.setType(null),
            ),
            ...PropertyType.values.map(
              (type) => _typeChip(
                label: _typeLabel(type),
                selected: filters.type == type,
                onTap: () => notifier.setType(type),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildPriceRange(
    BuildContext context,
    PropertyFilterNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual rent',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          '${_formatCurrency(_priceRange.start)} - '
          '${_formatCurrency(_priceRange.end)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          min: _minPrice,
          max: _maxPrice,
          divisions: 19,
          values: _priceRange,
          labels: RangeLabels(
            _formatCurrency(_priceRange.start),
            _formatCurrency(_priceRange.end),
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
          onChangeEnd: (values) {
            notifier.setMinPrice(values.start);
            notifier.setMaxPrice(values.end);
          },
        ),
      ],
    );
  }

  Widget _buildBedrooms(
    BuildContext context,
    PropertyFilterState filters,
    PropertyFilterNotifier notifier,
  ) {
    const options = [1, 2, 3, 4, 5];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bedrooms',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Any'),
              selected: filters.bedrooms == null,
              onSelected: (_) => notifier.setBedrooms(null),
            ),
            ...options.map(
              (bedrooms) => ChoiceChip(
                label: Text('$bedrooms+'),
                selected: filters.bedrooms == bedrooms,
                onSelected: (_) => notifier.setBedrooms(bedrooms),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, PropertyFilterNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              notifier.clearFilters();

              setState(() {
                _priceRange = const RangeValues(_minPrice, _maxPrice);
              });
            },
            child: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: widget.onApplied,
            child: const Text('Apply filters'),
          ),
        ),
      ],
    );
  }

  static String _typeLabel(PropertyType type) {
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

  static String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₦${(value / 1000000).toStringAsFixed(1)}m';
    }

    return '₦${(value / 1000).round()}k';
  }
}
