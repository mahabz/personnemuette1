import 'package:flutter/material.dart';
import '/page/sign_in_page.dart';
import '/page/sign_up_page.dart';
import '/../common_widget/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeInAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: media.width,
        height: media.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Cercle flou vert
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2),
                ),
              ),
            ),
            // Cercle supplémentaire en bas à droite
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
              ),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(height: media.width * 0.2),
                      // Logo
                      Image.asset(
                        'assets/logo.jpg',
                        width: media.width * 0.5,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Smart Sign Talk",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      // Bouton Sign In (gris foncé)
                      RoundButton(
                        title: "Sign in",
                        fontSize: 14,
                        textColor: Colors.white,
                        buttonColor: Colors.grey.shade800,
                        height: 45,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      // Bouton Sign Up (gris clair)
                      RoundButton(
                        title: "Sign up",
                        fontSize: 14,
                        textColor: Colors.white,
                        buttonColor: Colors.grey.shade600,
                        height: 45,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
