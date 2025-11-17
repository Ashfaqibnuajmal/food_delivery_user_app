import 'package:flutter_bloc/flutter_bloc.dart';

class FoodPortionCubit extends Cubit<bool> {
  FoodPortionCubit({bool initialHalf = false}) : super(initialHalf);
  void selectHalf() => emit(true);
  void selectFull() => emit(false);
  void toggle() => emit(!state);
}
