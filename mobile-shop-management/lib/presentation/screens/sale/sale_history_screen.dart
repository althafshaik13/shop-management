import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/sale_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../../domain/enums/product_type.dart';
import '../../../domain/enums/payment_status.dart';

class SaleHistoryScreen extends StatefulWidget {
  const SaleHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SaleHistoryScreen> createState() => _SaleHistoryScreenState();
}

class _SaleHistoryScreenState extends State<SaleHistoryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  ProductType? _filterProductType;
  PaymentStatus? _filterPaymentStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSales();
    });
  }

  void _loadSales() {
    context.read<SaleProvider>().loadSales(
          startDate: _startDate,
          endDate: _endDate,
          productType: _filterProductType,
          paymentStatus: _filterPaymentStatus,
        );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadSales();
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProductType?>(
              value: _filterProductType,
              decoration: const InputDecoration(
                labelText: 'Product Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...ProductType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() => _filterProductType = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PaymentStatus?>(
              value: _filterPaymentStatus,
              decoration: const InputDecoration(
                labelText: 'Payment Status',
                prefixIcon: Icon(Icons.payment),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...PaymentStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() => _filterPaymentStatus = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _loadSales();
              },
              child: const Text('Apply Filters'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _filterProductType = null;
                  _filterPaymentStatus = null;
                });
                Navigator.pop(context);
                _loadSales();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale History'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0A0A),
                Color(0xFF1C1C1C),
                Color(0xFF330000),
                Color(0xFF5C0000),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSales,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1C1C1C),
              Color(0xFF330000),
              Color(0xFF5C0000),
            ],
          ),
        ),
        child: Column(
          children: [
            if (_startDate != null && _endDate != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                        _loadSales();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Consumer<SaleProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.sales.isEmpty) {
                    return const LoadingWidget(message: 'Loading sales...');
                  }

                  if (provider.errorMessage != null && provider.sales.isEmpty) {
                    return ErrorDisplayWidget(
                      message: provider.errorMessage!,
                      onRetry: _loadSales,
                    );
                  }

                  if (provider.sales.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.white38,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No sales found',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first sale to see it here',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  }

                  // Calculate totals
                  double totalRevenue = 0;
                  double totalProfit = 0;
                  for (var sale in provider.sales) {
                    totalRevenue += sale.calculatedTotal;
                    totalProfit += sale.calculatedProfit;
                  }

                  return Column(
                    children: [
                      // Summary Card
                      Card(
                        margin: const EdgeInsets.all(8),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total Sales',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '${provider.sales.length}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Revenue',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    currencyFormat.format(totalRevenue),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Profit',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    currencyFormat.format(totalProfit),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Sales List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: provider.sales.length,
                          itemBuilder: (context, index) {
                            final sale = provider.sales[index];
                            return Card(
                              child: ExpansionTile(
                                title: Text(
                                  'Sale #${sale.id}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (sale.saleDate != null)
                                      Text(dateFormat.format(sale.saleDate!)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getPaymentStatusColor(
                                                sale.paymentStatus),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            sale.paymentStatus.displayName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sale.paymentType.displayName,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  currencyFormat.format(sale.calculatedTotal),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (sale.customerName != null) ...[
                                          Text(
                                            'Customer: ${sale.customerName}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (sale.customerPhone != null)
                                            Text(
                                                'Phone: ${sale.customerPhone}'),
                                          if (sale.customerAddress != null)
                                            Text(
                                                'Address: ${sale.customerAddress}'),
                                          const Divider(height: 24),
                                        ],
                                        const Text(
                                          'Items:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        ...sale.items.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${item.productType.displayName} #${item.productId}',
                                                ),
                                                Text(
                                                  '${item.quantity} × ${currencyFormat.format(item.customerPrice)} = ${currencyFormat.format(item.totalAmount)}',
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        const Divider(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Profit:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              currencyFormat.format(
                                                  sale.calculatedProfit),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.fullPaid:
        return Colors.green;
      case PaymentStatus.partialPaid:
        return Colors.orange;
      case PaymentStatus.unpaid:
        return Colors.red;
    }
  }
}
