import 'package:flutter/material.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/review_dialog.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/restaurant_detail_widget.dart';
import 'package:gugugu/presentation/features/restaurant/widgets/restaurant_add_dialog.dart';

class RestaurantMapScreen extends StatefulWidget {
  const RestaurantMapScreen({super.key});

  @override
  State<RestaurantMapScreen> createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  late KakaoMapController mapController;
  final Set<Marker> markers = {};
  bool isDetailVisible = false;
  Map<String, dynamic>? selectedRestaurant;
  final List<Map<String, dynamic>> _restaurants = [
    {
      'id': '1',
      'name': '맛있는 식당',
      'address': '서울시 강남구 테헤란로 123',
      'image': 'https://picsum.photos/200',
      'rating': 4.8,
      'lat': 37.5665,
      'lng': 126.9780,
      'menu': ['불고기 15,000원', '비빔밥 12,000원', '김치찌개 10,000원'],
      'comments': [
        {'user': '홍길동', 'content': '맛있어요!', 'rating': 5.0},
        {'user': '김철수', 'content': '가격이 좀 비싸요', 'rating': 3.0},
      ],
    },
    {
      'id': '2',
      'name': '맛집 2호점',
      'address': '서울시 강남구 역삼로 456',
      'image': 'https://picsum.photos/201',
      'rating': 4.7,
      'lat': 37.5666,
      'lng': 126.9781,
      'menu': ['삼겹살 18,000원', '목살 16,000원', '소주 4,000원'],
      'comments': [
        {'user': '이영희', 'content': '고기가 신선해요', 'rating': 5.0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initMarkers();
  }

  void _initMarkers() {
    for (var restaurant in _restaurants) {
      markers.add(
        Marker(
          markerId: restaurant['id'],
          latLng: LatLng(restaurant['lat'], restaurant['lng']),
          width: 30,
          height: 30,
        ),
      );
    }
  }

  void _showRestaurantDetail(String markerId) {
    for (var item in _restaurants) {
      if (item['id'] != markerId) return;
      setState(() {
        selectedRestaurant = item;
        isDetailVisible = true;
      });
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => ReviewDialog(
        onSubmit: (content, rating, imagePath) {
          setState(() {
            selectedRestaurant!['comments'].add({
              'user': '나',
              'content': content,
              'rating': rating,
              'image': imagePath,
            });
          });
        },
      ),
    );
  }

  void _showAddRestaurantDialog() {
    showDialog(
      context: context,
      builder: (context) => RestaurantAddDialog(
        onSubmit: (name, address, lat, lng, menu) {
          setState(() {
            _restaurants.add({
              'id': DateTime.now().toString(),
              'name': name,
              'address': address,
              'image': 'https://picsum.photos/200',
              'rating': 0.0,
              'lat': lat,
              'lng': lng,
              'menu': menu,
              'comments': [],
            });
          });
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
      bottomNavigationBar: isDetailVisible? null :const CustomBottomNavigation(
        currentIndex: 1,
      ),
      body: Stack(
        children: [
          KakaoMap(
              onMapTap: (_) {
                if (!isDetailVisible) {
                  return;
                }
                setState(() {
                  isDetailVisible = false;
                  mapController.setDraggable(true);
                });
              },
              onMapCreated: (controller) {
                mapController = controller;
                controller.addMarker(markers: markers.toList());
              },
              center: LatLng(37.5665, 126.9780),
              currentLevel: 3,
              onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {
                _showRestaurantDetail(markerId);
                mapController.setDraggable(false);
              },
            ),

          if (isDetailVisible && selectedRestaurant != null)
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
                              imageUrl: selectedRestaurant!['image'],
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
                                  selectedRestaurant!['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(selectedRestaurant!['address']),
                                const SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: selectedRestaurant!['rating'],
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
                              const Text(
                                '메뉴',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...selectedRestaurant!['menu'].map<Widget>((menu) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(menu),
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
                              ...selectedRestaurant!['comments'].map<Widget>((comment) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment['user'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            RatingBar.builder(
                                              initialRating: comment['rating'],
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
                                        Text(comment['content']),
                                        if (comment['image'] != null) ...[
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: comment['image'],
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ],
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
                    Padding(
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
                                isDetailVisible = false;
                                mapController.setDraggable(true);
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }
} 