import 'package:flutter/material.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:gugugu/presentation/features/hot_place/providers/hot_place_provider.dart';
import 'package:gugugu/presentation/features/hot_place/screens/hot_place_detail_screen.dart';
import 'package:provider/provider.dart';

class HotPlaceScreen extends StatefulWidget {
  const HotPlaceScreen({super.key});

  @override
  State<HotPlaceScreen> createState() => _HotPlaceScreenState();
}

class _HotPlaceScreenState extends State<HotPlaceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<HotPlaceProvider>();
      provider.loadHotPlace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('핫플레이스 TOP 10'),

        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<HotPlaceProvider>(
        builder: (context, hotPlaceProvider, _) {
          if (hotPlaceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (hotPlaceProvider.error != null) {
            return Center(child: Text(hotPlaceProvider.error!));
          }

          return ListView.builder(
            itemCount: hotPlaceProvider.restaurants.length,
            itemBuilder: (context, index) {

              final place = hotPlaceProvider.restaurants[index];
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
                            place.imageUrl ?? "",
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
                                place.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                place.address,
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
                                    place.averageRating.toStringAsFixed(2),
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
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 2,
      ),
    );
  }
} 