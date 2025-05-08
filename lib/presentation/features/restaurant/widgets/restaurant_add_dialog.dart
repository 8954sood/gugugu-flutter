import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:gugugu/presentation/features/restaurant/screens/location_picker_screen.dart';

class RestaurantAddDialog extends StatefulWidget {
  final Function(String name, String address, double lat, double lng, List<String> menu) onSubmit;

  const RestaurantAddDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<RestaurantAddDialog> createState() => _RestaurantAddDialogState();
}

class _RestaurantAddDialogState extends State<RestaurantAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _menuController = TextEditingController();
  final List<String> _menuItems = [];
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _addMenuItem() {
    if (_menuController.text.isNotEmpty) {
      setState(() {
        _menuItems.add(_menuController.text);
        _menuController.clear();
      });
    }
  }

  void _removeMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialPosition: _selectedLocation ?? LatLng(37.5665, 126.9780),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _menuController,
                      decoration: const InputDecoration(
                        labelText: '메뉴',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addMenuItem,
                  ),
                ],
              ),
              if (_menuItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  '추가된 메뉴',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._menuItems.asMap().entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeMenuItem(entry.key),
                    ),
                  );
                }).toList(),
              ],
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
                      _addressController.text,
                      _selectedLocation!.latitude,
                      _selectedLocation!.longitude,
                      List.from(_menuItems),
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