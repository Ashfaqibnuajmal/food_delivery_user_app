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

  // 🔹 Optional: Reset filters
  void resetFilters() {
    emit(const SearchFilterState());
  }
}
