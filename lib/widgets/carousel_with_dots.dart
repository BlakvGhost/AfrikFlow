import 'package:afrik_flow/themes/app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithDots extends StatefulWidget {
  const CarouselWithDots({super.key});

  @override
  CarouselWithDotsState createState() => CarouselWithDotsState();
}

class CarouselWithDotsState extends State<CarouselWithDots> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: CarouselSlider(
              items: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18.0),
                    bottomRight: Radius.circular(18.0),
                  ),
                  child: Image.asset(
                    'assets/onboard/onboard1.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18.0),
                    bottomRight: Radius.circular(18.0),
                  ),
                  child: Image.asset(
                    'assets/onboard/onboard2.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ],
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
          ),
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [0, 1].map((index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? AppTheme.primaryColor
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
