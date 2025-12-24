import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class CategoryImageRotationCubit extends Cubit<int> {
  final int imageCount;
  Timer? _timer;
  CategoryImageRotationCubit({required this.imageCount}) : super(0) {
    _startRotation();
  }
  void _startRotation() {
    if (imageCount <= 1) return;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      emit((state + 1) % imageCount);
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
