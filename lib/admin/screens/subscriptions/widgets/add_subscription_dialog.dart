import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/subscription_model.dart';
import '../../../../utils/validators.dart';

class AddSubscriptionDialog extends StatefulWidget {
  final Function(SubscriptionPlanModel) onSave;

  const AddSubscriptionDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featureInputController = TextEditingController();

  String _selectedBilling = 'Monthly';
  bool _isPopular = false;
  bool _isActive = true;

  final List<String> _features = [];
  final List<String> _billingCycles = ['Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Lifetime'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _featureInputController.dispose();
    super.dispose();
  }

  void _addFeature() {
    final text = _featureInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _features.add(text);
        _featureInputController.clear();
      });
    }
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_features.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one feature for this plan.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }

      final newPlan = SubscriptionPlanModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        planName: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        billingCycle: _selectedBilling,
        description: _descriptionController.text.trim(),
        features: List.from(_features),
        isPopular: _isPopular,
        isActive: _isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(newPlan);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 550,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Subscription Plan',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Name
                      Text('Plan Name', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('e.g. Monthly Professional'),
                        validator: (value) => Validators.required(value, 'Plan Name'),
                      ),
                      const SizedBox(height: 16),

                      // Price & Billing Cycle Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price (\$)', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _priceController,
                                  decoration: _inputDecoration('e.g. 49.00'),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  validator: (value) => Validators.price(value),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Billing Cycle', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedBilling,
                                  items: _billingCycles.map((cycle) {
                                    return DropdownMenuItem(value: cycle, child: Text(cycle));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedBilling = val;
                                      });
                                    }
                                  },
                                  decoration: _inputDecoration(''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text('Description', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: _inputDecoration('Enter plan description...'),
                        validator: (value) => Validators.required(value, 'Description'),
                      ),
                      const SizedBox(height: 16),

                      // Dynamic Features List Builder
                      Text('Features', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _featureInputController,
                              decoration: _inputDecoration('Enter a feature detail...'),
                              onFieldSubmitted: (_) => _addFeature(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _addFeature,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rendered features list with delete options
                      if (_features.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            children: List.generate(_features.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check, color: Color(0xFF16A34A), size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _features[index],
                                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF374151)),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeFeature(index),
                                      icon: const Icon(Icons.close_rounded, size: 14, color: Color(0xFFEF4444)),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Switches Row
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              title: Text(
                                'Popular Plan',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              value: _isPopular,
                              activeColor: const Color(0xFF16A34A),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                setState(() {
                                  _isPopular = val;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SwitchListTile(
                              title: Text(
                                'Active Status',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              value: _isActive,
                              activeColor: const Color(0xFF16A34A),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                setState(() {
                                  _isActive = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: const Color(0xFF4B5563), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Save Plan',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.withOpacity(0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
      ),
    );
  }
}
