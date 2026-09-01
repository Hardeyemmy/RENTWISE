enum PropertyType { apartment, house, office, duplex, studio }

class Property {
  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.city,
    required this.price,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.imageUrl,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String location;
  final String city;
  final double price;
  final PropertyType type;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String imageUrl;
  final bool isFeatured;

  String get typeLabel {
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

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      price: (json['price'] as num).toDouble(),
      type: PropertyType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => PropertyType.apartment,
      ),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      area: (json['area'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'city': city,
      'price': price,
      'type': type.name,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
    };
  }
}
