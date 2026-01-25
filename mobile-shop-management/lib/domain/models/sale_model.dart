import 'package:equatable/equatable.dart';
import '../enums/payment_type.dart';
import '../enums/payment_status.dart';
import 'sale_item_model.dart';

class SaleModel extends Equatable {
  final int? id;
  final DateTime? saleDate;
  final double? totalAmount;
  final List<SaleItemModel> items;
  final PaymentType paymentType;
  final PaymentStatus paymentStatus;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;

  const SaleModel({
    this.id,
    this.saleDate,
    this.totalAmount,
    required this.items,
    required this.paymentType,
    required this.paymentStatus,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as int?,
      saleDate: json['saleDate'] != null
          ? DateTime.parse(json['saleDate'] as String)
          : null,
      totalAmount: json['totalAmount'] != null
          ? (json['totalAmount'] as num).toDouble()
          : null,
      items: (json['items'] as List<dynamic>)
          .map((item) => SaleItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == json['paymentType'],
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
      ),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerAddress: json['customerAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (saleDate != null) 'saleDate': saleDate!.toIso8601String(),
      if (totalAmount != null) 'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
      'paymentType': paymentType.name,
      'paymentStatus': paymentStatus.name,
      if (customerName != null) 'customerName': customerName,
      if (customerPhone != null) 'customerPhone': customerPhone,
      if (customerAddress != null) 'customerAddress': customerAddress,
    };
  }

  double get calculatedTotal =>
      items.fold(0, (sum, item) => sum + item.totalAmount);

  double get calculatedProfit =>
      items.fold(0, (sum, item) => sum + item.profit);

  @override
  List<Object?> get props => [
    id,
    saleDate,
    totalAmount,
    items,
    paymentType,
    paymentStatus,
    customerName,
    customerPhone,
    customerAddress,
  ];
}
