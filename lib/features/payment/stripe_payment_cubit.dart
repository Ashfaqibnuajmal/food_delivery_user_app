import 'package:flutter_bloc/flutter_bloc.dart';

class StripePaymentCubit extends Cubit<bool> {
  StripePaymentCubit() : super(false);

  void markPaid() => emit(true);

  void reset() => emit(false);
}
