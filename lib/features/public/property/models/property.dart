class Property {
  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.state,
    required this.price,
    required this.propertyType,
    required this.listingType,
    required this.status,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.images,
    required this.amenities,
    required this.latitude,
    required this.longitude,
    required this.isFeatured,
    required this.createdAt,
    this.address,
    this.yearBuilt,
    this.parkingSpaces,
    this.agent,
  });

  final String id;
  final String title;
  final String description;

  /// Short/local area name.
  final String location;

  final String city;
  final String state;

  /// Rental or sale price depending on [listingType].
  final double price;

  final PropertyType propertyType;
  final ListingType listingType;
  final PropertyStatus status;

  final int bedrooms;
  final int bathrooms;

  /// Property size in square metres.
  final double area;

  final List<String> images;
  final List<String> amenities;

  final double latitude;
  final double longitude;

  final bool isFeatured;

  final DateTime createdAt;

  final String? address;
  final int? yearBuilt;
  final int? parkingSpaces;

  final PropertyAgent? agent;

  String get propertyTypeLabel {
    switch (propertyType) {
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

  String get listingTypeLabel {
    switch (listingType) {
      case ListingType.rent:
        return 'For Rent';
      case ListingType.sale:
        return 'For Sale';
    }
  }

  String get statusLabel {
    switch (status) {
      case PropertyStatus.available:
        return 'Available';
      case PropertyStatus.rented:
        return 'Rented';
      case PropertyStatus.sold:
        return 'Sold';
      case PropertyStatus.pending:
        return 'Pending';
    }
  }

  /// Backwards-compatible alias for existing widgets.
  String get typeLabel => propertyTypeLabel;

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      price: (json['price'] as num).toDouble(),

      propertyType: PropertyType.values.firstWhere(
        (type) => type.name == json['propertyType'],
        orElse: () => PropertyType.apartment,
      ),

      listingType: ListingType.values.firstWhere(
        (type) => type.name == json['listingType'],
        orElse: () => ListingType.rent,
      ),

      status: PropertyStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => PropertyStatus.available,
      ),

      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0,

      images: List<String>.from(
        json['images'] as List? ?? const [],
      ),

      amenities: List<String>.from(
        json['amenities'] as List? ?? const [],
      ),

      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,

      isFeatured: json['isFeatured'] as bool? ?? false,

      createdAt: DateTime.tryParse(
            json['createdAt'] as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),

      address: json['address'] as String?,
      yearBuilt: (json['yearBuilt'] as num?)?.toInt(),
      parkingSpaces: (json['parkingSpaces'] as num?)?.toInt(),

      agent: json['agent'] != null
          ? PropertyAgent.fromJson(
              Map<String, dynamic>.from(json['agent'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'city': city,
      'state': state,
      'price': price,
      'propertyType': propertyType.name,
      'listingType': listingType.name,
      'status': status.name,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'images': images,
      'amenities': amenities,
      'latitude': latitude,
      'longitude': longitude,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'yearBuilt': yearBuilt,
      'parkingSpaces': parkingSpaces,
      'agent': agent?.toJson(),
    };
  }
}

enum PropertyType {
  apartment,
  house,
  duplex,
  studio,
  office,
}

enum ListingType {
  rent,
  sale,
}

enum PropertyStatus {
  available,
  rented,
  sold,
  pending,
}

class PropertyAgent {
  const PropertyAgent({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final bool isVerified;

  factory PropertyAgent.fromJson(Map<String, dynamic> json) {
    return PropertyAgent(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
    };
  }
}