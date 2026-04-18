part of 'checkout_cubit.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {}

class CheckoutFailure extends CheckoutState {
  final String message;
  CheckoutFailure(this.message);
}
