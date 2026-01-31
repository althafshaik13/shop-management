import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final int? id;
  final String name;
  final String? subtitle;
  final double dealerPrice;
  final double customerPrice;
  final int quantity;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    Key? key,
    this.id,
    required this.name,
    this.subtitle,
    required this.dealerPrice,
    required this.customerPrice,
    required this.quantity,
    this.imageUrl,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.white.withOpacity(0.1),
                          child: const Icon(Icons.image, color: Colors.white70),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.white.withOpacity(0.1),
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.white.withOpacity(0.1),
                        child:
                            const Icon(Icons.inventory, color: Colors.white70),
                      ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Dealer: ${currencyFormat.format(dealerPrice)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.sell,
                            size: 16, color: Colors.greenAccent),
                        const SizedBox(width: 4),
                        Text(
                          'Customer: ${currencyFormat.format(customerPrice)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: quantity > 0
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: quantity > 0
                              ? Colors.greenAccent.withOpacity(0.5)
                              : Colors.redAccent.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Stock: $quantity',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: quantity > 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              if (onEdit != null || onDelete != null)
                Column(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                        color: Colors.blueAccent,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: onDelete,
                        color: Colors.redAccent,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
