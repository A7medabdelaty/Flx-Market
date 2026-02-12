import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class AddProductImagePicked extends AddProductEvent {
  final XFile image;

  const AddProductImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class AddProductSubmitted extends AddProductEvent {
  final String name;
  final String description;
  final double price;
  final String location;
  final bool isFeatured;
  final String ownerId;
  final String category;

  const AddProductSubmitted({
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.ownerId,
    required this.category,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [name, description, price, location, isFeatured, ownerId, category];
}
