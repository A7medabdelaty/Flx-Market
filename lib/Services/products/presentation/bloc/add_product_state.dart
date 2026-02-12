import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();
  
  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFailure extends AddProductState {
  final String message;

  const AddProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AddProductImageSelected extends AddProductState {
  final File imageFile;

  const AddProductImageSelected(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
