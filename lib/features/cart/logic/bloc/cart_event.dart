import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Map<String, dynamic> item;
  const AddToCart(this.item);
  @override
  List<Object?> get props => [];
}

class RemoveCartItems extends CartEvent {
  final String itemId;
  const RemoveCartItems(this.itemId);
  @override
  List<Object?> get props => [];
}

class LoadCarts extends CartEvent {
  const LoadCarts();
}

class UpdateCartItemQuantity extends CartEvent {
  final String id;
  final int quantity;

  const UpdateCartItemQuantity({required this.id, required this.quantity});
}

class ClearCart extends CartEvent {}
