import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/providers/banner_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselWithDots extends ConsumerStatefulWidget {
  const CarouselWithDots({super.key});

  @override
  CarouselWithDotsState createState() => CarouselWithDotsState();
}

class CarouselWithDotsState extends ConsumerState<CarouselWithDots> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(bannerProvider.notifier).fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);

    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: banners.isEmpty
                ? const Center(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                : Column(
                    children: [
                      CarouselSlider(
                        items: banners.map((banner) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.black,
                              child: CachedNetworkImage(
                                imageUrl: banner.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, size: 50),
                                fit: BoxFit.cover,
                              ),
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
                  ),
          ),
        ),
      ],
    );
  }
}
