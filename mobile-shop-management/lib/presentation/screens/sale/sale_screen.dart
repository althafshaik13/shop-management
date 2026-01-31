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
      backgroundColor: Colors.transparent,
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Sale Items Section
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _addItem,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Item'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.1),
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Consumer<SaleProvider>(
                              builder: (context, provider, child) {
                                if (provider.currentSaleItems.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Text(
                                        'No items added yet',
                                        style: TextStyle(color: Colors.white70),
                                      ),
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
                                        color: Colors.white.withOpacity(0.05),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          title: Text(
                                            '${item.productType.displayName} #${item.productId}',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            'Qty: ${item.quantity} × ${currencyFormat.format(item.customerPrice)}',
                                            style: TextStyle(
                                                color: Colors.white70),
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
                                                  color: Colors.white,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  provider
                                                      .removeSaleItem(index);
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
                                                color: Colors.white,
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
                                                color: Colors.greenAccent,
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
                                          ).textTheme.bodyLarge?.copyWith(
                                                color: Colors.white,
                                              ),
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
                                                color: Colors.blueAccent,
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
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Details (Optional)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
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
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<PaymentType>(
                              value: _paymentType,
                              dropdownColor: const Color(0xFF1C1C1C),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Payment Type',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.payment,
                                    color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCC0000),
                                    width: 2,
                                  ),
                                ),
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
                              dropdownColor: const Color(0xFF1C1C1C),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Payment Status',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.credit_card,
                                    color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCC0000),
                                    width: 2,
                                  ),
                                ),
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
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
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
    return Container(
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProductType>(
                value: _productType,
                dropdownColor: const Color(0xFF1C1C1C),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Product Type',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.category, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFCC0000),
                      width: 2,
                    ),
                  ),
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
                      dropdownColor: const Color(0xFF1C1C1C),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Select Battery',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.battery_charging_full,
                            color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCC0000),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.withOpacity(0.7),
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
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
                      dropdownColor: const Color(0xFF1C1C1C),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Select Spare Part',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            const Icon(Icons.build, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCC0000),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.withOpacity(0.7),
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
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
                Text(
                  'Dealer Price: ₹${_dealerPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Customer Price: ₹${_customerPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70),
                ),
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
      ),
    );
  }
}
