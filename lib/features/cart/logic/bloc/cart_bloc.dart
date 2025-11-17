import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<LoadCarts>(_onLoadCartItems);
    on<AddToCart>(_onAddCart);
    on<RemoveCartItems>(_onRemoveCart);
    on<ClearCart>(_onClearCart);

    // ✅ New: Handle quantity updates
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);

    add(const LoadCarts());
  }

  Future<void> _onLoadCartItems(
    LoadCarts event,
    Emitter<CartState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final List<Map<String, dynamic>> loaded = decoded
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      emit(state.copyWith(cartItems: loaded));
    }
  }

  Future<void> _onAddCart(AddToCart event, Emitter<CartState> emit) async {
    final updated = List<Map<String, dynamic>>.from(state.cartItems);
    final exist = updated.any((item) => item['id'] == event.item['id']);
    if (!exist) {
      updated.add(event.item);
      emit(state.copyWith(cartItems: updated));
      await _saveToCart(updated);
    }
  }

  Future<void> _onRemoveCart(
    RemoveCartItems event,
    Emitter<CartState> emit,
  ) async {
    final updated = List<Map<String, dynamic>>.from(state.cartItems)
      ..removeWhere((item) => item['id'] == event.itemId);
    emit(state.copyWith(cartItems: updated));
    await _saveToCart(updated);
  }

  // ✅ New: Update quantity of a cart item
  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final updatedCartItems = state.cartItems.map((item) {
      if (item['id'] == event.id) {
        return {
          ...item,
          'quantity': event.quantity, // update quantity
        };
      }
      return item;
    }).toList();

    emit(state.copyWith(cartItems: updatedCartItems));
    await _saveToCart(updatedCartItems); // save updated cart
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(cartItems: []));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    await prefs.remove('coolDrinkBottomSheetShown'); // reset flag here too
  }

  Future<void> _saveToCart(List<Map<String, dynamic>> cartItems) async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cartItems);
    await pref.setString('cart', jsonString);
  }
}
