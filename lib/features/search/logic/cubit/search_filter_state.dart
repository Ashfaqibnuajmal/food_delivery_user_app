import 'package:equatable/equatable.dart';

class SearchFilterState extends Equatable {
  final bool showFavoritesOnly;
  final bool showComboOnly;

  const SearchFilterState({
    this.showFavoritesOnly = false,
    this.showComboOnly = false,
  });

  SearchFilterState copyWith({bool? showFavoritesOnly, bool? showComboOnly}) {
    return SearchFilterState(
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      showComboOnly: showComboOnly ?? this.showComboOnly,
    );
  }

  @override
  List<Object?> get props => [showFavoritesOnly, showComboOnly];
}
