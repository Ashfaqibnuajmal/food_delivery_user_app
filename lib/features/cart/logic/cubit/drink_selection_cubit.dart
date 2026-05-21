import 'package:flutter_bloc/flutter_bloc.dart';

class DrinkSelectionCubit extends Cubit<List<Map<String, dynamic>>> {
  DrinkSelectionCubit() : super([]);

  bool isSelected(String id) => state.any((d) => d['id'] == id);

  void toggleSelection(Map<String, dynamic> item) {
    final updatedList = List<Map<String, dynamic>>.from(state);
    final index = updatedList.indexWhere((d) => d['id'] == item['id']);

    if (index != -1) {
      updatedList.removeAt(index);
    } else {
      updatedList.add(item);
    }
    emit(updatedList);
  }

  void clearSelection() => emit([]);

  bool get hasSelection => state.isNotEmpty;
}
