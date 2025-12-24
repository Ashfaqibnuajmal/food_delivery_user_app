import 'package:flutter_bloc/flutter_bloc.dart';

class SearchFilterCubit extends Cubit<bool> {
  SearchFilterCubit() : super(false);

  void toggleFavorites(bool value) => emit(value);

  void reset() => emit(false);
}
