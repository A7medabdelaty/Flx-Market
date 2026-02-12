import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/home_entities.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final Product product;

  const ToggleWishlistEvent(this.product);

  @override
  List<Object?> get props => [product];
}
