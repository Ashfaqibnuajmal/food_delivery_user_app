import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';

class SelectPaymentCubit extends Cubit<PaymentMode> {
  SelectPaymentCubit() : super(PaymentMode.cod);
  void changeMode(PaymentMode selected) => emit(selected);
}
