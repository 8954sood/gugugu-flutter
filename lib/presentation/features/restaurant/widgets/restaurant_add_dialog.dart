import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:gugugu/presentation/features/restaurant/screens/location_picker_screen.dart';

class RestaurantAddDialog extends StatefulWidget {
  final LatLng userLocation;
  final Function(String name, String description, String address, double lat, double lng) onSubmit;

  const RestaurantAddDialog({
    super.key,
    required this.userLocation,
    required this.onSubmit,
  });

  @override
  State<RestaurantAddDialog> createState() => _RestaurantAddDialogState();
}

class _RestaurantAddDialogState extends State<RestaurantAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  Future<void> _pickLocation() async {
    final result = await Navigator.push<(LatLng, String)>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialPosition: widget.userLocation,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result.$1;
        _addressController.text = result.$2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('맛집 추가'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '식당 이름',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '식당 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '주소',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickLocation,
                icon: const Icon(Icons.location_on),
                label: Text(_selectedLocation == null
                    ? '위치 선택'
                    : '위도: ${_selectedLocation!.latitude.toStringAsFixed(6)}\n경도: ${_selectedLocation!.longitude.toStringAsFixed(6)}'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '맛집에 대한 설명을 입력해주세요';
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
          onPressed: _selectedLocation == null
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _nameController.text,
                      _descriptionController.text,
                      _addressController.text,
                      _selectedLocation!.latitude,
                      _selectedLocation!.longitude,
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