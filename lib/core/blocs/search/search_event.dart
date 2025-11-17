// food_search_event.dart
import 'package:equatable/equatable.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();

  @override
  List<Object?> get props => [];
}

// Update query when typing in search bar
class UpdateQuery extends FoodSearchEvent {
  final String query;
  const UpdateQuery(this.query);

  @override
  List<Object?> get props => [query];
}

// Set all items from Firestore
class SetFoodItems extends FoodSearchEvent {
  final List<Map<String, dynamic>> items;
  const SetFoodItems(this.items);

  @override
  List<Object?> get props => [items];
}
