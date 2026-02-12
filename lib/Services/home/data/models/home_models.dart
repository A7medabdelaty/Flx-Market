import '../../domain/entities/home_entities.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.iconPath,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      iconPath: map['iconPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'iconPath': iconPath};
  }
}

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.location,
    required super.imageUrl,
    super.ownerId,
    super.price,
    super.description,
    super.isFeatured,
    super.isFavorite,
    super.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      ownerId: map['ownerId'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
      'ownerId': ownerId,
      'category': category,
    };
  }
}
