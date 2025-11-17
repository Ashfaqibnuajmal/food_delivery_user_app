import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/blocs/search/search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  FoodSearchBloc() : super(const FoodSearchState()) {
    on<SetFoodItems>((event, emit) {
      emit(state.copyWith(allItems: event.items));
    });

    on<UpdateQuery>((event, emit) {
      emit(state.copyWith(query: event.query));
    });
  }
}
