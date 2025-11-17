import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorite>(_onAddFavorite);
    on<RemoveFromFavorite>(_onRemoveFavorite);

    add(const LoadFavorites());
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final List<Map<String, dynamic>> loaded =
          decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      emit(state.copyWith(favorites: loaded));
    }
  }

  Future<void> _onAddFavorite(
      AddToFavorite event, Emitter<FavoriteState> emit) async {
    final updated = List<Map<String, dynamic>>.from(state.favorites);
    final exists = updated.any((item) => item['id'] == event.item['id']);
    if (!exists) {
      updated.add(event.item);
      emit(state.copyWith(favorites: updated));
      await _saveToLocal(updated); // ✅ Save after add
    }
  }

  // -----------------------------
  // Remove from favorite
  // -----------------------------
  Future<void> _onRemoveFavorite(
      RemoveFromFavorite event, Emitter<FavoriteState> emit) async {
    final updated = List<Map<String, dynamic>>.from(state.favorites)
      ..removeWhere((item) => item['id'] == event.itemId);
    emit(state.copyWith(favorites: updated));
    await _saveToLocal(updated); // ✅ Save after remove
  }

  // -----------------------------
  // Save to SharedPreferences
  // -----------------------------
  Future<void> _saveToLocal(List<Map<String, dynamic>> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(favorites);
    await prefs.setString('favorites', jsonString);
  }
}
