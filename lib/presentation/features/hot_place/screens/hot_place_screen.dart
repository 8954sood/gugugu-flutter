import 'package:flutter/material.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:gugugu/presentation/features/hot_place/screens/hot_place_detail_screen.dart';

class HotPlaceScreen extends StatelessWidget {
  const HotPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hotPlaces = [
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('핫플레이스 TOP 10'),

        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: hotPlaces.length,
        itemBuilder: (context, index) {
          final place = hotPlaces[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotPlaceDetailScreen(place: place),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        place['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place['address'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place['rating'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 2,
      ),
    );
  }
} 