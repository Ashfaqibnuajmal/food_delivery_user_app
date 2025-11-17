import 'package:flutter_bloc/flutter_bloc.dart';

class FoodCategoryFilterCubit extends Cubit<String?> {
  FoodCategoryFilterCubit() : super(null);
  void selectCategory(String categoryName) {
    emit(categoryName);
  }

  void clearCategory() {
    emit(null);
  }
}
