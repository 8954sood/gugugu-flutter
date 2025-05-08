import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';
import 'package:gugugu/core/widgets/app_card.dart';
import 'package:gugugu/core/widgets/app_button.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const LocationPickerScreen({
    super.key,
    this.initialPosition,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  KakaoMapController? mapController;
  LatLng? selectedLocation;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialPosition ?? LatLng(37.5665, 126.9780);
  }

  void _updateMarker() async {
    final controller = mapController;
    final location = selectedLocation;
    if (controller == null || location == null) return;

    final marker = Marker(
      markerId: 'selected_location',
      latLng: location,
      width: 30,
      height: 30,
    );
    markers.clear();
    markers.add(marker);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 선택', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onMapTap: (latLng) {
              setState(() {
                selectedLocation = latLng;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateMarker();
              });
            },
            center: selectedLocation!,
            currentLevel: 3,
            markers: markers.toList(),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지도를 탭하여 위치를 선택하세요',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (selectedLocation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '위도: ${selectedLocation!.latitude.toStringAsFixed(6)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '경도: ${selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  text: '취소',
                  isOutlined: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  text: '선택',
                  onPressed: selectedLocation == null
                      ? null
                      : () => Navigator.pop(context, selectedLocation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 