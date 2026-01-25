import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/sale_provider.dart';
import '../../providers/battery_provider.dart';
import '../../providers/spare_part_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../domain/models/sale_item_model.dart';
import '../../../domain/enums/product_type.dart';
import '../../../domain/enums/payment_type.dart';
import '../../../domain/enums/payment_status.dart';
import '../../../core/utils/validators.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key}) : super(key: key);

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();

  PaymentType _paymentType = PaymentType.CASH;
  PaymentStatus _paymentStatus = PaymentStatus.fullPaid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BatteryProvider>().loadBatteries();
      context.read<SparePartProvider>().loadSpareParts();
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    super.dispose();
  }

  void _addItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddSaleItemSheet(
        onItemAdded: (item) {
          context.read<SaleProvider>().addSaleItem(item);
        },
      ),
    );
  }

  Future<void> _completeSale() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<SaleProvider>();

      if (provider.currentSaleItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one item'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await provider.createSale(
        paymentType: _paymentType,
        paymentStatus: _paymentStatus,
        customerName: _customerNameController.text.isEmpty
            ? null
            : _customerNameController.text,
        customerPhone: _customerPhoneController.text.isEmpty
            ? null
            : _customerPhoneController.text,
        customerAddress: _customerAddressController.text.isEmpty
            ? null
            : _customerAddressController.text,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sale completed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Failed to complete sale'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          Consumer<SaleProvider>(
            builder: (context, provider, child) {
              if (provider.currentSaleItems.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    provider.clearCurrentSale();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sale cleared')),
                    );
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Sale Items Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sale Items',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              ElevatedButton.icon(
                                onPressed: _addItem,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Item'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Consumer<SaleProvider>(
                            builder: (context, provider, child) {
                              if (provider.currentSaleItems.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Text('No items added yet'),
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  ...provider.currentSaleItems
                                      .asMap()
                                      .entries
                                      .map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        title: Text(
                                          '${item.productType.displayName} #${item.productId}',
                                        ),
                                        subtitle: Text(
                                          'Qty: ${item.quantity} × ${currencyFormat.format(item.customerPrice)}',
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              currencyFormat.format(
                                                item.totalAmount,
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                provider.removeSaleItem(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const Divider(height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        currencyFormat.format(
                                          provider.currentSaleTotal,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Profit:',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        currencyFormat.format(
                                          provider.currentSaleProfit,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Customer Details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Details (Optional)',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Customer Name',
                            controller: _customerNameController,
                            prefixIcon: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Customer Phone',
                            controller: _customerPhoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone),
                            maxLength: 10,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Customer Address',
                            controller: _customerAddressController,
                            maxLines: 3,
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Payment Details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<PaymentType>(
                            value: _paymentType,
                            decoration: const InputDecoration(
                              labelText: 'Payment Type',
                              prefixIcon: Icon(Icons.payment),
                            ),
                            items: PaymentType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.displayName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _paymentType = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<PaymentStatus>(
                            value: _paymentStatus,
                            decoration: const InputDecoration(
                              labelText: 'Payment Status',
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                            items: PaymentStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status.displayName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _paymentStatus = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Consumer<SaleProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Complete Sale',
                    onPressed: _completeSale,
                    isLoading: provider.isLoading,
                    icon: Icons.check_circle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSaleItemSheet extends StatefulWidget {
  final Function(SaleItemModel) onItemAdded;

  const _AddSaleItemSheet({required this.onItemAdded});

  @override
  State<_AddSaleItemSheet> createState() => _AddSaleItemSheetState();
}

class _AddSaleItemSheetState extends State<_AddSaleItemSheet> {
  final _formKey = GlobalKey<FormState>();
  ProductType _productType = ProductType.BATTERY;
  int? _selectedProductId;
  final _quantityController = TextEditingController(text: '1');
  double? _dealerPrice;
  double? _customerPrice;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Sale Item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProductType>(
              value: _productType,
              decoration: const InputDecoration(
                labelText: 'Product Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: ProductType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _productType = value;
                    _selectedProductId = null;
                    _dealerPrice = null;
                    _customerPrice = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_productType == ProductType.BATTERY)
              Consumer<BatteryProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<int>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Select Battery',
                      prefixIcon: Icon(Icons.battery_charging_full),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a battery' : null,
                    items: provider.batteries.map((battery) {
                      return DropdownMenuItem(
                        value: battery.id,
                        child: Text(
                          '${battery.name} (Stock: ${battery.quantity})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final battery = provider.batteries.firstWhere(
                          (b) => b.id == value,
                        );
                        setState(() {
                          _selectedProductId = value;
                          _dealerPrice = battery.dealerPrice;
                          _customerPrice = battery.customerPrice;
                        });
                      }
                    },
                  );
                },
              )
            else
              Consumer<SparePartProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<int>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Select Spare Part',
                      prefixIcon: Icon(Icons.build),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a spare part' : null,
                    items: provider.spareParts.map((sparePart) {
                      return DropdownMenuItem(
                        value: sparePart.id,
                        child: Text(
                          '${sparePart.name} (Stock: ${sparePart.quantity})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final sparePart = provider.spareParts.firstWhere(
                          (s) => s.id == value,
                        );
                        setState(() {
                          _selectedProductId = value;
                          _dealerPrice = sparePart.dealerPrice;
                          _customerPrice = sparePart.customerPrice;
                        });
                      }
                    },
                  );
                },
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Quantity',
              controller: _quantityController,
              keyboardType: TextInputType.number,
              validator: Validators.validateQuantity,
              prefixIcon: const Icon(Icons.numbers),
            ),
            if (_dealerPrice != null && _customerPrice != null) ...[
              const SizedBox(height: 16),
              Text('Dealer Price: ₹${_dealerPrice!.toStringAsFixed(2)}'),
              Text('Customer Price: ₹${_customerPrice!.toStringAsFixed(2)}'),
            ],
            const SizedBox(height: 24),
            CustomButton(
              text: 'Add Item',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final item = SaleItemModel(
                    productType: _productType,
                    productId: _selectedProductId!,
                    quantity: int.parse(_quantityController.text),
                    dealerPrice: _dealerPrice!,
                    customerPrice: _customerPrice!,
                  );
                  widget.onItemAdded(item);
                  Navigator.pop(context);
                }
              },
              icon: Icons.add,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
