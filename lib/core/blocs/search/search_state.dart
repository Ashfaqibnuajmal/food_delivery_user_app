// food_search_state.dart
import 'package:equatable/equatable.dart';

class FoodSearchState extends Equatable {
  final List<Map<String, dynamic>> allItems;
  final String query;
  final bool isListening;

  const FoodSearchState({
    this.allItems = const [],
    this.query = '',
    this.isListening = false,
  });

  List<Map<String, dynamic>> get filteredItems {
    if (query.isEmpty) return allItems;
    return allItems
        .where((item) => (item['name'] ?? '')
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  FoodSearchState copyWith({
    List<Map<String, dynamic>>? allItems,
    String? query,
    bool? isListening,
  }) {
    return FoodSearchState(
      allItems: allItems ?? this.allItems,
      query: query ?? this.query,
      isListening: isListening ?? this.isListening,
    );
  }

  @override
  List<Object?> get props => [allItems, query, isListening];
}
