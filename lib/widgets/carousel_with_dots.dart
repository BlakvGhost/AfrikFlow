import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/models/banner.dart' as home_banner;

class CarouselWithDots extends StatefulWidget {
  const CarouselWithDots({super.key});

  @override
  CarouselWithDotsState createState() => CarouselWithDotsState();
}

class CarouselWithDotsState extends State<CarouselWithDots> {
  int _currentIndex = 0;
  late Future<List<home_banner.Banner>> _banners;

  @override
  void initState() {
    super.initState();
    _banners = ApiService().fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: FutureBuilder<List<home_banner.Banner>>(
              future: _banners,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final banners = snapshot.data!;
                  return Column(
                    children: [
                      CarouselSlider(
                        items: banners.map((banner) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.network(
                              banner.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('Failed to load image');
                              },
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 8),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(banners.length, (index) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                } else {
                  return const Text('Aucune bannière disponible');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
