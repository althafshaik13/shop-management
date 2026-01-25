enum PaymentStatus {
  fullPaid,
  partialPaid,
  unpaid;

  String get displayName {
    switch (this) {
      case PaymentStatus.fullPaid:
        return 'Full Paid';
      case PaymentStatus.partialPaid:
        return 'Partial Paid';
      case PaymentStatus.unpaid:
        return 'Unpaid';
    }
  }
}
