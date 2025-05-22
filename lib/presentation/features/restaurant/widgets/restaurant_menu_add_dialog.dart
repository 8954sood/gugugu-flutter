import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:gugugu/presentation/features/restaurant/screens/location_picker_screen.dart';

class RestaurantMenuAddDialog extends StatefulWidget {
  final Function(String name, String description, int price) onSubmit;

  const RestaurantMenuAddDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<RestaurantMenuAddDialog> createState() => _RestaurantMenuAddDialogState();
}

class _RestaurantMenuAddDialogState extends State<RestaurantMenuAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('메뉴 추가'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '메뉴 이름',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '메뉴 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: '가격',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '가격을 입력해주세요';
                  }
                  return null;
                },

              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _nameController.text,
                      _descriptionController.text,
                      int.parse(_priceController.text),
                    );
                    Navigator.pop(context);
                  }
                },
          child: const Text('추가'),
        ),
      ],
    );
  }
} 