import 'package:equatable/equatable.dart';

class SparePartModel extends Equatable {
  final int? id;
  final String name;
  final String? category;
  final double dealerPrice;
  final double customerPrice;
  final int quantity;
  final String? imageUrl;
  final DateTime? createdAt;

  const SparePartModel({
    this.id,
    required this.name,
    this.category,
    required this.dealerPrice,
    required this.customerPrice,
    required this.quantity,
    this.imageUrl,
    this.createdAt,
  });

  factory SparePartModel.fromJson(Map<String, dynamic> json) {
    return SparePartModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      category: json['category'] as String?,
      dealerPrice: (json['dealerPrice'] as num).toDouble(),
      customerPrice: (json['customerPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (category != null) 'category': category,
      'dealerPrice': dealerPrice,
      'customerPrice': customerPrice,
      'quantity': quantity,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  SparePartModel copyWith({
    int? id,
    String? name,
    String? category,
    double? dealerPrice,
    double? customerPrice,
    int? quantity,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return SparePartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      dealerPrice: dealerPrice ?? this.dealerPrice,
      customerPrice: customerPrice ?? this.customerPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    dealerPrice,
    customerPrice,
    quantity,
    imageUrl,
    createdAt,
  ];
}
