import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/spare_part_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/models/spare_part_model.dart';

class SparePartFormScreen extends StatefulWidget {
  final SparePartModel? sparePart;

  const SparePartFormScreen({Key? key, this.sparePart}) : super(key: key);

  @override
  State<SparePartFormScreen> createState() => _SparePartFormScreenState();
}

class _SparePartFormScreenState extends State<SparePartFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _dealerPriceController;
  late final TextEditingController _customerPriceController;
  late final TextEditingController _quantityController;

  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.sparePart != null;

  @override
  void initState() {
    super.initState();
    final sparePart = widget.sparePart;
    _nameController = TextEditingController(text: sparePart?.name);
    _categoryController = TextEditingController(text: sparePart?.category);
    _dealerPriceController = TextEditingController(
      text: sparePart?.dealerPrice.toString(),
    );
    _customerPriceController = TextEditingController(
      text: sparePart?.customerPrice.toString(),
    );
    _quantityController = TextEditingController(
      text: sparePart?.quantity.toString(),
    );
    _imageUrl = sparePart?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
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
        final provider = context.read<SparePartProvider>();
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

  Future<void> _saveSparePart() async {
    if (_formKey.currentState?.validate() ?? false) {
      final sparePart = SparePartModel(
        id: widget.sparePart?.id,
        name: _nameController.text,
        category: _categoryController.text.isEmpty
            ? null
            : _categoryController.text,
        dealerPrice: double.parse(_dealerPriceController.text),
        customerPrice: double.parse(_customerPriceController.text),
        quantity: int.parse(_quantityController.text),
        imageUrl: _imageUrl,
      );

      final provider = context.read<SparePartProvider>();
      final bool success;

      if (isEditing) {
        success = await provider.updateSparePart(
          widget.sparePart!.id!,
          sparePart,
        );
      } else {
        success = await provider.createSparePart(sparePart);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Spare part updated successfully'
                    : 'Spare part created successfully',
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
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Spare Part' : 'Add Spare Part'),
      ),
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
                        ? const Icon(Icons.build, size: 64)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Consumer<SparePartProvider>(
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
              label: 'Category (Optional)',
              controller: _categoryController,
              prefixIcon: const Icon(Icons.category),
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
            Consumer<SparePartProvider>(
              builder: (context, provider, child) {
                return CustomButton(
                  text: isEditing ? 'Update Spare Part' : 'Add Spare Part',
                  onPressed: _saveSparePart,
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
