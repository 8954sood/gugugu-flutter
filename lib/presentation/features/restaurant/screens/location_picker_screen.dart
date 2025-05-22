import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gugugu/presentation/utiles/utiles.dart';
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
  String? selectedAddress;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialPosition ?? LatLng(37.5665, 126.9780);
    Future.microtask(() async {
      selectedAddress = await getAddressFromLatLng(selectedLocation!.latitude, selectedLocation!.longitude);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
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
    controller.clear();
    markers.add(marker);

    if (!mounted) return;
    setState(() {});
  }

  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print("주소 변환 오류: $e");
    }
    return null;
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
            key: const ValueKey('kakao_picker_map'),
            onMapCreated: (controller) {
              if (!mounted) return;
              print("created");
              setState(() {
                mapController = controller;
              });
            },
            onMapTap: (latLng) {
              if (!mounted) return;
              setState(() {
                selectedLocation = latLng;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                selectedAddress = await getAddressFromLatLng(selectedLocation!.latitude, selectedLocation!.longitude);
                setState(() {});
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
                      '주소: $selectedAddress',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
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
                      : () {
                    Navigator.pop(context, (selectedLocation, selectedAddress));
                  } ,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
} 