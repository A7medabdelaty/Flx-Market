class Category {
  final String id;
  final String name;
  final String iconPath;

  const Category({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}

class Product {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double price;
  final String description;
  final bool isFeatured;
  final bool isFavorite;
  final String ownerId;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.price = 0.0,
    this.description = '',
    this.isFeatured = false,
    this.isFavorite = false,
    this.ownerId = '',
    this.category = '',
  });
}
