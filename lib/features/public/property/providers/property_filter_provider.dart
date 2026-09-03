import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';

class PropertyFilterState {
  const PropertyFilterState({
    this.searchQuery = '',
    this.location = '',
    this.type,
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.sortBy = PropertySort.newest,
  });

  final String searchQuery;
  final String location;
  final PropertyType? type;
  final double? minPrice;
  final double? maxPrice;
  final int? bedrooms;
  final PropertySort sortBy;

  PropertyFilterState copyWith({
    String? searchQuery,
    String? location,
    PropertyType? type,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    PropertySort? sortBy,
    bool clearType = false,
    bool clearBedrooms = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return PropertyFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      location: location ?? this.location,
      type: clearType ? null : type ?? this.type,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      bedrooms: clearBedrooms ? null : bedrooms ?? this.bedrooms,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return type != null ||
        minPrice != null ||
        maxPrice != null ||
        bedrooms != null ||
        sortBy != PropertySort.newest;
  }
}

enum PropertySort { newest, priceLowToHigh, priceHighToLow, bedrooms }

class PropertyFilterNotifier extends Notifier<PropertyFilterState> {
  @override
  PropertyFilterState build() {
    return const PropertyFilterState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setType(PropertyType? type) {
    if (type == null) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(type: type);
    }
  }

  void setMinPrice(double? minPrice) {
    if (minPrice == null) {
      state = state.copyWith(clearMinPrice: true);
    } else {
      state = state.copyWith(minPrice: minPrice);
    }
  }

  void setMaxPrice(double? maxPrice) {
    if (maxPrice == null) {
      state = state.copyWith(clearMaxPrice: true);
    } else {
      state = state.copyWith(maxPrice: maxPrice);
    }
  }

  void setBedrooms(int? bedrooms) {
    if (bedrooms == null) {
      state = state.copyWith(clearBedrooms: true);
    } else {
      state = state.copyWith(bedrooms: bedrooms);
    }
  }

  void setSort(PropertySort sort) {
    state = state.copyWith(sortBy: sort);
  }

  void clearFilters() {
    state = const PropertyFilterState();
  }
}

final propertyFilterProvider =
    NotifierProvider<PropertyFilterNotifier, PropertyFilterState>(
      PropertyFilterNotifier.new,
    );
