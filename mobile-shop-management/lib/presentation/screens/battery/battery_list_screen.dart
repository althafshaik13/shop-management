import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/battery_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/product_card.dart';
import 'battery_form_screen.dart';

class BatteryListScreen extends StatefulWidget {
  const BatteryListScreen({Key? key}) : super(key: key);

  @override
  State<BatteryListScreen> createState() => _BatteryListScreenState();
}

class _BatteryListScreenState extends State<BatteryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BatteryProvider>().loadBatteries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batteries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BatteryProvider>().loadBatteries();
            },
          ),
        ],
      ),
      body: Consumer<BatteryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.batteries.isEmpty) {
            return const LoadingWidget(message: 'Loading batteries...');
          }

          if (provider.errorMessage != null && provider.batteries.isEmpty) {
            return ErrorDisplayWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.loadBatteries(),
            );
          }

          if (provider.batteries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.battery_unknown,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No batteries found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add your first battery using the + button'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.batteries.length,
            itemBuilder: (context, index) {
              final battery = provider.batteries[index];
              return ProductCard(
                id: battery.id,
                name: battery.name,
                subtitle:
                    '${battery.modelNumber} | ${battery.capacity} | ${battery.voltage}',
                dealerPrice: battery.dealerPrice,
                customerPrice: battery.customerPrice,
                quantity: battery.quantity,
                imageUrl: battery.imageUrl,
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BatteryFormScreen(battery: battery),
                    ),
                  );
                  if (result == true && mounted) {
                    provider.loadBatteries();
                  }
                },
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Battery'),
                      content: Text(
                        'Are you sure you want to delete ${battery.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && battery.id != null) {
                    final success = await provider.deleteBattery(battery.id!);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Battery deleted successfully'
                                : provider.errorMessage ??
                                      'Failed to delete battery',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BatteryFormScreen()),
          );
          if (result == true && mounted) {
            context.read<BatteryProvider>().loadBatteries();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Battery'),
      ),
    );
  }
}
