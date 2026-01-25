enum PaymentType {
  CASH,
  ONLINE;

  String get displayName {
    switch (this) {
      case PaymentType.CASH:
        return 'Cash';
      case PaymentType.ONLINE:
        return 'Online';
    }
  }
}
