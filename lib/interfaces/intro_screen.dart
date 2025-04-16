import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import '/page/another_screen.dart'; // Import de AnotherScreen

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> backgroundImages = [
    "assets/back1.jpg",
    "assets/back2.jpg",
    "assets/back3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with background images
          PageView.builder(
            controller: _pageController,
            itemCount: backgroundImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildSection(
                backgroundImage: backgroundImages[index],
                title: _getTitle(index),
                subtitle: _getSubtitle(index),
              );
            },
          ),

          // Bottom Navigation
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _buildBottomNavigationBar(context),
          ),

          // Floating icon button that opens AnotherScreen
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnotherScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: 'Mode caméra gestuelle',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[800], // Gris foncé
                    padding: const EdgeInsets.all(18),
                    shape: const CircleBorder(),
                    elevation: 6,
                    shadowColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestes & Voix',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String backgroundImage,
    required String title,
    String? subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) const SizedBox(height: 12),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                backgroundImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_currentPage < backgroundImages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                }
              },
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "HandTalk ";
      case 1:
        return "Available Nationwide";
      case 2:
        return "Learn & Communicate Easily";
      default:
        return "";
    }
  }

  String? _getSubtitle(int index) {
    switch (index) {
      case 0:
        return "Breaking barriers in silent communication.";
      case 1:
        return "Accessible in all major cities across the country.";
      case 2:
        return "Interactive sign language learning and real-time translation.";
      default:
        return null;
    }
  }
}
