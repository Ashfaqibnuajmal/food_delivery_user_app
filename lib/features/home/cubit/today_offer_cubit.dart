import 'package:flutter_bloc/flutter_bloc.dart';

class TodayOfferCubit extends Cubit<int> {
  TodayOfferCubit() : super(0);
  void changeIndex(int index) => emit(index);
}
