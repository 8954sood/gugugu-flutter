import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/restaurant_add_dialog.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/restaurant_menu_add_dialog.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/review_dialog.dart';
import 'package:gugugu/presentation/utiles/utiles.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/presentation/features/restaurant/providers/restaurant_provider.dart';

class RestaurantMapScreen extends StatefulWidget {
  const RestaurantMapScreen({super.key});

  @override
  State<RestaurantMapScreen> createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  final _searchController = TextEditingController();
  List<Marker> _markers = [];
  late LatLng _nowPosition;
  KakaoMapController? _mapController;
  bool _isDetailVisible = false;
  Restaurant? _selectedRestaurant;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadNearbyRestaurants());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadNearbyRestaurants() async {
    final position = await _getCurrentPosition();
    if (!mounted) return;

    context.read<RestaurantProvider>().loadNearbyRestaurants(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<LatLng> _getCurrentPosition() async {
    _nowPosition = await getCurrentPosition();
    return _nowPosition;
  }

  void _showRestaurantDetail(String markerId) {
    for (var item in context.read<RestaurantProvider>().restaurants) {
      if (item.id.toString() != markerId) continue;
      setState(() {
        _selectedRestaurant = item;
        _isDetailVisible = true;
      });
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => ReviewDialog(
        onSubmit: (content, rating, description) async {
          final newComment = await context.read<RestaurantProvider>().createComment(restaurantId: _selectedRestaurant!.id, rating: rating, content: content);
          setState(() {
            _selectedRestaurant = _selectedRestaurant?.copyWith(
              comment: _selectedRestaurant!.comment..add(newComment)
            );
          });
        },
      ),
    );
  }

  void _showAddRestaurantDialog() {
    showDialog(
      context: context,
      builder: (context) => RestaurantAddDialog(
        userLocation: _nowPosition,
        onSubmit: (name, address, lat, lng) {
          context.read<RestaurantProvider>().createRestaurant(
            Restaurant(id: Random.secure().nextInt(3000), name: name, address: address, latitude: lat, longitude: lng, description: "", averageRating: 0.0, reviewCount: 0, menu: [], comment: [], createdAt: DateTime.now(), updatedAt: DateTime.now(), )
          );
        },
      ),
    );
  }

  void _showMenuAddRestaurantDialog(
      int restaurantId,
  ) {
    showDialog(
      context: context,
      builder: (context) => RestaurantMenuAddDialog(
        onSubmit: (name, description, price) async {
          final newMenu = await context.read<RestaurantProvider>().createMenu(
            restaurantId: restaurantId,
            name: name,
            description:description,
            price: price,
          );

          if (_selectedRestaurant != null) {
            _selectedRestaurant = _selectedRestaurant?.copyWith(
              menu: _selectedRestaurant?.menu?..add(newMenu)
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 지도'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddRestaurantDialog,
            tooltip: '맛집 추가',
          ),
        ],
      ),
      bottomNavigationBar: _isDetailVisible? null :const CustomBottomNavigation(
        currentIndex: 1,
      ),
      body: Stack(
        children: [
          Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                if (provider.restaurants.isNotEmpty) {
                  _updateMarkers(provider.restaurants);
                }

                return Stack(
                  children: [
                    KakaoMap(
                      key: const ValueKey("kakao_map_key"),
                      onMapCreated: (controller) {
                        _mapController = controller;
                        if (_markers.isNotEmpty) {
                          _mapController?.addMarker(markers: _markers);
                        }
                        controller.setCenter(_nowPosition);
                      },
                      center: LatLng(37.5665, 126.9780),
                      currentLevel: 3,
                      onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {
                        final restaurant = provider.restaurants.firstWhere(
                          (r) => r.id.toString() == markerId,
                        );
                        _showRestaurantDetail(restaurant.id.toString());
                        _mapController?.setDraggable(false);
                      },
                    ),
                    if (_isDetailVisible && _selectedRestaurant != null)
                      GestureDetector(
                        onTap: () {
                          if (!_isDetailVisible) return;
                          setState(() {
                            _isDetailVisible = false;
                            _mapController?.setDraggable(true);
                          });
                        },
                        child: Container(color: Colors.transparent ,width: double.infinity, height: double.infinity,),
                      ),
                    if (_isDetailVisible && _selectedRestaurant != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: _selectedRestaurant!.imageUrl ?? "",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedRestaurant!.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(_selectedRestaurant!.address),
                                            const SizedBox(height: 8),
                                            RatingBar.builder(
                                              initialRating: _selectedRestaurant!.averageRating,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              ignoreGestures: true,
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: NotificationListener<ScrollNotification>(
                                    onNotification: (ScrollNotification notification) {
                                      return true; // 스크롤 이벤트를 여기서 중단
                                    },
                                    child: SingleChildScrollView(
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '메뉴',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(onPressed: () {
                                                _showMenuAddRestaurantDialog(_selectedRestaurant!.id);
                                              }, icon: const Icon(Icons.add)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ..._selectedRestaurant!.menu.map<Widget>((menu) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(menu.name),
                                                  Text("${menu.price}원")
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          const SizedBox(height: 16),
                                          const Text(
                                            '리뷰',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ..._selectedRestaurant!.comment.map<Widget>((comment) {
                                            return Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "의문의 대소고인${comment.id}",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        RatingBar.builder(
                                                          initialRating: comment.rating,
                                                          minRating: 1,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 16,
                                                          ignoreGestures: true,
                                                          itemBuilder: (context, _) => const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate: (rating) {},
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(comment.content),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _showReviewDialog,
                                            child: const Text('리뷰 작성'),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isDetailVisible = false;
                                              _mapController?.setDraggable(true);
                                            });
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  void _updateMarkers(List<Restaurant> restaurants) {
    _markers = restaurants
        .map((item) => Marker(
            markerId: item.id.toString(),
            latLng: LatLng(item.latitude, item.longitude,)
          )
        )
        .toList();
    _mapController?.addMarker(markers: _markers);
  }
}