enum PaymentMode { cod, stripe }

String paymentModeToString(PaymentMode mode) {
  switch (mode) {
    case PaymentMode.cod:
      return "Cash on Delivery";
    case PaymentMode.stripe:
      return "Stripe";
  }
}
