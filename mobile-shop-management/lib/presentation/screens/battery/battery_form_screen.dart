import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/battery_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/models/battery_model.dart';

class BatteryFormScreen extends StatefulWidget {
  final BatteryModel? battery;

  const BatteryFormScreen({Key? key, this.battery}) : super(key: key);

  @override
  State<BatteryFormScreen> createState() => _BatteryFormScreenState();
}

class _BatteryFormScreenState extends State<BatteryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _modelController;
  late final TextEditingController _capacityController;
  late final TextEditingController _voltageController;
  late final TextEditingController _warrantyController;
  late final TextEditingController _dealerPriceController;
  late final TextEditingController _customerPriceController;
  late final TextEditingController _quantityController;

  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.battery != null;

  @override
  void initState() {
    super.initState();
    final battery = widget.battery;
    _nameController = TextEditingController(text: battery?.name);
    _modelController = TextEditingController(text: battery?.modelNumber);
    _capacityController = TextEditingController(text: battery?.capacity);
    _voltageController = TextEditingController(text: battery?.voltage);
    _warrantyController = TextEditingController(
      text: battery?.warrantyPeriodInMonths.toString(),
    );
    _dealerPriceController = TextEditingController(
      text: battery?.dealerPrice.toString(),
    );
    _customerPriceController = TextEditingController(
      text: battery?.customerPrice.toString(),
    );
    _quantityController = TextEditingController(
      text: battery?.quantity.toString(),
    );
    _imageUrl = battery?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    _voltageController.dispose();
    _warrantyController.dispose();
    _dealerPriceController.dispose();
    _customerPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final provider = context.read<BatteryProvider>();
        final imageUrl = await provider.uploadImage(image.path);

        if (imageUrl != null) {
          setState(() {
            _imageUrl = imageUrl;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image uploaded successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Failed to upload image'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveBattery() async {
    if (_formKey.currentState?.validate() ?? false) {
      final battery = BatteryModel(
        id: widget.battery?.id,
        name: _nameController.text,
        modelNumber: _modelController.text,
        capacity: _capacityController.text,
        voltage: _voltageController.text,
        warrantyPeriodInMonths: int.parse(_warrantyController.text),
        dealerPrice: double.parse(_dealerPriceController.text),
        customerPrice: double.parse(_customerPriceController.text),
        quantity: int.parse(_quantityController.text),
        imageUrl: _imageUrl,
      );

      final provider = context.read<BatteryProvider>();
      final bool success;

      if (isEditing) {
        success = await provider.updateBattery(widget.battery!.id!, battery);
      } else {
        success = await provider.createBattery(battery);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Battery updated successfully'
                    : 'Battery created successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Operation failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Battery' : 'Add Battery')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: _imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageUrl == null
                        ? const Icon(Icons.battery_charging_full, size: 64)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Consumer<BatteryProvider>(
                    builder: (context, provider, child) {
                      return TextButton.icon(
                        onPressed: provider.isUploading ? null : _pickImage,
                        icon: provider.isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.camera_alt),
                        label: Text(
                          provider.isUploading
                              ? 'Uploading...'
                              : 'Change Image',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Name',
              controller: _nameController,
              validator: (value) => Validators.validateRequired(value, 'Name'),
              prefixIcon: const Icon(Icons.title),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Model Number',
              controller: _modelController,
              validator: (value) =>
                  Validators.validateRequired(value, 'Model Number'),
              prefixIcon: const Icon(Icons.numbers),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Capacity (e.g., 150Ah)',
              controller: _capacityController,
              validator: (value) =>
                  Validators.validateRequired(value, 'Capacity'),
              prefixIcon: const Icon(Icons.power),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Voltage (e.g., 12V)',
              controller: _voltageController,
              validator: (value) =>
                  Validators.validateRequired(value, 'Voltage'),
              prefixIcon: const Icon(Icons.electric_bolt),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Warranty Period (months)',
              controller: _warrantyController,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  Validators.validatePositiveNumber(value, 'Warranty Period'),
              prefixIcon: const Icon(Icons.verified),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dealer Price',
              controller: _dealerPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: Validators.validatePrice,
              prefixIcon: const Icon(Icons.shopping_cart),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Customer Price',
              controller: _customerPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: Validators.validatePrice,
              prefixIcon: const Icon(Icons.sell),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Quantity',
              controller: _quantityController,
              keyboardType: TextInputType.number,
              validator: Validators.validateQuantity,
              prefixIcon: const Icon(Icons.inventory),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 32),
            Consumer<BatteryProvider>(
              builder: (context, provider, child) {
                return CustomButton(
                  text: isEditing ? 'Update Battery' : 'Add Battery',
                  onPressed: _saveBattery,
                  isLoading: provider.isLoading,
                  icon: isEditing ? Icons.save : Icons.add,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
