import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentIndex = 0;

  final List<Widget> splashImages = [
    Image.asset('assets/splash/splash_1.png',
        fit: BoxFit.cover, width: double.infinity),
    Stack(children: [
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash/splash_2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        color: Colors.black.withOpacity(0.5), // Fond semi-transparent
        width: double.infinity,
        height: double.infinity,
      ),
      const Center(
        child: Text(
          'Welcome to AfrikFlow',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            items: splashImages,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          if (_currentIndex == 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Réduit la rondeur des coins
                        ),
                      ),
                      child: const Text('Se connecter',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Déjà inscrit?',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
