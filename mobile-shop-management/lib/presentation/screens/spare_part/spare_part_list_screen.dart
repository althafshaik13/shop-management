import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spare_part_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/product_card.dart';
import 'spare_part_form_screen.dart';

class SparePartListScreen extends StatefulWidget {
  const SparePartListScreen({Key? key}) : super(key: key);

  @override
  State<SparePartListScreen> createState() => _SparePartListScreenState();
}

class _SparePartListScreenState extends State<SparePartListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SparePartProvider>().loadSpareParts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spare Parts'),
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SparePartProvider>().loadSpareParts();
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
        child: Consumer<SparePartProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.spareParts.isEmpty) {
              return const LoadingWidget(message: 'Loading spare parts...');
            }

            if (provider.errorMessage != null && provider.spareParts.isEmpty) {
              return ErrorDisplayWidget(
                message: provider.errorMessage!,
                onRetry: () => provider.loadSpareParts(),
              );
            }

            if (provider.spareParts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.build_circle_outlined,
                      size: 64,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No spare parts found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first spare part using the + button',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.spareParts.length,
              itemBuilder: (context, index) {
                final sparePart = provider.spareParts[index];
                return ProductCard(
                  id: sparePart.id,
                  name: sparePart.name,
                  subtitle: sparePart.category,
                  dealerPrice: sparePart.dealerPrice,
                  customerPrice: sparePart.customerPrice,
                  quantity: sparePart.quantity,
                  imageUrl: sparePart.imageUrl,
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SparePartFormScreen(sparePart: sparePart),
                      ),
                    );
                    if (result == true && mounted) {
                      provider.loadSpareParts();
                    }
                  },
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Spare Part'),
                        content: Text(
                          'Are you sure you want to delete ${sparePart.name}?',
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

                    if (confirmed == true && sparePart.id != null) {
                      final success = await provider.deleteSparePart(
                        sparePart.id!,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Spare part deleted successfully'
                                  : provider.errorMessage ??
                                      'Failed to delete spare part',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SparePartFormScreen(),
            ),
          );
          if (result == true && mounted) {
            context.read<SparePartProvider>().loadSpareParts();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Spare Part'),
      ),
    );
  }
}
