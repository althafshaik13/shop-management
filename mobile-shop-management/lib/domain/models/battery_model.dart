import 'package:equatable/equatable.dart';

class BatteryModel extends Equatable {
  final int? id;
  final String name;
  final String modelNumber;
  final String capacity;
  final String voltage;
  final int warrantyPeriodInMonths;
  final double dealerPrice;
  final double customerPrice;
  final int quantity;
  final String? imageUrl;

  const BatteryModel({
    this.id,
    required this.name,
    required this.modelNumber,
    required this.capacity,
    required this.voltage,
    required this.warrantyPeriodInMonths,
    required this.dealerPrice,
    required this.customerPrice,
    required this.quantity,
    this.imageUrl,
  });

  factory BatteryModel.fromJson(Map<String, dynamic> json) {
    return BatteryModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      modelNumber: json['modelNumber'] as String,
      capacity: json['capacity'] as String,
      voltage: json['voltage'] as String,
      warrantyPeriodInMonths: json['warrantyPeriodInMonths'] as int,
      dealerPrice: (json['dealerPrice'] as num).toDouble(),
      customerPrice: (json['customerPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'modelNumber': modelNumber,
      'capacity': capacity,
      'voltage': voltage,
      'warrantyPeriodInMonths': warrantyPeriodInMonths,
      'dealerPrice': dealerPrice,
      'customerPrice': customerPrice,
      'quantity': quantity,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  BatteryModel copyWith({
    int? id,
    String? name,
    String? modelNumber,
    String? capacity,
    String? voltage,
    int? warrantyPeriodInMonths,
    double? dealerPrice,
    double? customerPrice,
    int? quantity,
    String? imageUrl,
  }) {
    return BatteryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      modelNumber: modelNumber ?? this.modelNumber,
      capacity: capacity ?? this.capacity,
      voltage: voltage ?? this.voltage,
      warrantyPeriodInMonths:
          warrantyPeriodInMonths ?? this.warrantyPeriodInMonths,
      dealerPrice: dealerPrice ?? this.dealerPrice,
      customerPrice: customerPrice ?? this.customerPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    modelNumber,
    capacity,
    voltage,
    warrantyPeriodInMonths,
    dealerPrice,
    customerPrice,
    quantity,
    imageUrl,
  ];
}
