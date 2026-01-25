enum ProductType {
  SPARE_PART,
  BATTERY;

  String get displayName {
    switch (this) {
      case ProductType.SPARE_PART:
        return 'Spare Part';
      case ProductType.BATTERY:
        return 'Battery';
    }
  }
}
