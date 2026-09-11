import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_property.dart';
import '../models/property.dart';
import 'property_filter_provider.dart';

final propertyListProvider = Provider<List<Property>>((ref) {
  return MockProperty.properties;
});

final filteredPropertiesProvider = Provider<List<Property>>((ref) {
  final properties = ref.watch(propertyListProvider);
  final filters = ref.watch(propertyFilterProvider);

  final query = filters.searchQuery.trim().toLowerCase();
  final location = filters.location.trim().toLowerCase();

  var results = properties.where((property) {
    // Search
    final matchesSearch =
        query.isEmpty ||
        property.title.toLowerCase().contains(query) ||
        property.description.toLowerCase().contains(query) ||
        property.location.toLowerCase().contains(query) ||
        property.city.toLowerCase().contains(query) ||
        property.state.toLowerCase().contains(query) ||
        (property.address?.toLowerCase().contains(query) ?? false);

    // Location
    final matchesLocation =
        location.isEmpty ||
        property.city.toLowerCase().contains(location) ||
        property.state.toLowerCase().contains(location) ||
        property.location.toLowerCase().contains(location) ||
        (property.address?.toLowerCase().contains(location) ?? false);

    // Property type
    final matchesType =
        filters.type == null || property.propertyType == filters.type;

    // Minimum price
    final matchesMinPrice =
        filters.minPrice == null || property.price >= filters.minPrice!;

    // Maximum price
    final matchesMaxPrice =
        filters.maxPrice == null || property.price <= filters.maxPrice!;

    // Bedrooms
    final matchesBedrooms =
        filters.bedrooms == null || property.bedrooms >= filters.bedrooms!;

    return matchesSearch &&
        matchesLocation &&
        matchesType &&
        matchesMinPrice &&
        matchesMaxPrice &&
        matchesBedrooms;
  }).toList();

  // Sorting
  switch (filters.sortBy) {
    case PropertySort.newest:
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;

    case PropertySort.priceLowToHigh:
      results.sort((a, b) => a.price.compareTo(b.price));
      break;

    case PropertySort.priceHighToLow:
      results.sort((a, b) => b.price.compareTo(a.price));
      break;

    case PropertySort.bedrooms:
      results.sort((a, b) => b.bedrooms.compareTo(a.bedrooms));
      break;
  }

  return results;
});
