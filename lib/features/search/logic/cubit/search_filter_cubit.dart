import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit() : super(const SearchFilterState());

  // 🔹 Toggle Favorites filter
  void toggleFavorites(bool value) {
    emit(state.copyWith(showFavoritesOnly: value));
  }

  // 🔹 Toggle Combo Food filter
  void toggleCompoFood(bool value) {
    emit(state.copyWith(showComboOnly: value));
  }

  // 🆕 Update Price Range filter (ONLY stores values)
  void updatePriceRange(double min, double max) {
    emit(state.copyWith(minPrice: min, maxPrice: max));
  }

  // ⭐ Set minimum rating filter
  void updateMinRating(int rating) {
    emit(state.copyWith(minRating: rating));
  }

  // ⭐ Clear rating filter (no rating applied)
  void clearRating() {
    emit(state.copyWith(minRating: null));
  }

  // 🔹 Optional: Reset filters
  void resetFilters() {
    emit(const SearchFilterState());
  }
}
