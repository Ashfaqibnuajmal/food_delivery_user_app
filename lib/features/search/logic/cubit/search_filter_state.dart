import 'package:equatable/equatable.dart';

class SearchFilterState extends Equatable {
  final bool showFavoritesOnly;
  final bool showComboOnly;

  // 🆕 Price range
  final double minPrice;
  final double maxPrice;

  const SearchFilterState({
    this.showFavoritesOnly = false,
    this.showComboOnly = false,

    // 🆕 Default price range
    this.minPrice = 10,
    this.maxPrice = 150,
  });

  SearchFilterState copyWith({
    bool? showFavoritesOnly,
    bool? showComboOnly,
    double? minPrice,
    double? maxPrice,
  }) {
    return SearchFilterState(
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      showComboOnly: showComboOnly ?? this.showComboOnly,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  @override
  List<Object?> get props => [
    showFavoritesOnly,
    showComboOnly,
    minPrice,
    maxPrice,
  ];
}
