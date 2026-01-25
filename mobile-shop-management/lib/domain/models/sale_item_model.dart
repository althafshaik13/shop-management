import 'package:equatable/equatable.dart';
import '../enums/product_type.dart';

class SaleItemModel extends Equatable {
  final ProductType productType;
  final int productId;
  final int quantity;
  final double dealerPrice;
  final double customerPrice;

  const SaleItemModel({
    required this.productType,
    required this.productId,
    required this.quantity,
    required this.dealerPrice,
    required this.customerPrice,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      productType: ProductType.values.firstWhere(
        (e) => e.name == json['productType'],
      ),
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      dealerPrice: (json['dealerPrice'] as num).toDouble(),
      customerPrice: (json['customerPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productType': productType.name,
      'productId': productId,
      'quantity': quantity,
      'dealerPrice': dealerPrice,
      'customerPrice': customerPrice,
    };
  }

  double get totalAmount => customerPrice * quantity;
  double get profit => (customerPrice - dealerPrice) * quantity;

  @override
  List<Object?> get props => [
    productType,
    productId,
    quantity,
    dealerPrice,
    customerPrice,
  ];
}
