import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony_app/screens/navbar.dart';
import 'login_screen.dart';
import 'dart:async';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shineAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    // Shining Effect Animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: false);

    _shineAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Pulse Effect for App Name
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 4));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isLoggedIn ? Navbar() : LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF880E4F), Color(0xFFE91E63)], // Updated Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating Particles Effect
          Positioned.fill(child: _buildParticleEffect()),

          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glassmorphic Logo with Ripple Effect
                _buildAnimatedLogo(),

                SizedBox(height: 20),

                // Glowing App Name
                _buildShiningAppTitle(),

                SizedBox(height: 10),

                // Tagline with Modern Feel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '"Where Souls Meet, Connections Grow"',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 40),

                // Sleek Modern Loader
                ModernLoader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Animated Logo with Ripple Effect
  Widget _buildAnimatedLogo() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: GlassmorphicContainer(
        width: 180,
        height: 180,
        borderRadius: 90,
        blur: 20,
        alignment: Alignment.center,
        border: 0.5,
        linearGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        ),
        borderGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.1)],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/matrimony_app_logo.jpeg',
            width: 170,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Floating Particles Effect
  Widget _buildParticleEffect() {
    return Stack(
      children: List.generate(10, (index) {
        Random random = Random();
        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          child: AnimatedOpacity(
            duration: Duration(seconds: 2),
            opacity: random.nextDouble(),
            child: Container(
              width: 5 + random.nextDouble() * 6,
              height: 5 + random.nextDouble() * 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Shining App Title with Glow
  Widget _buildShiningAppTitle() {
    return Stack(
      children: [
        Text(
          'SoulMate Connect',
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black38, blurRadius: 5)],
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-1 + _shineAnimation.value, 0),
                  end: Alignment(-1 + _shineAnimation.value + 0.5, 0),
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0),
                  ],
                  stops: [0.1, 0.5, 0.9],
                ).createShader(bounds);
              },
              child: Text(
                'SoulMate Connect',
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.transparent,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ModernLoader extends StatefulWidget {
  @override
  _ModernLoaderState createState() => _ModernLoaderState();
}

class _ModernLoaderState extends State<ModernLoader> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _waveAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _waveAnimations[index],
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Opacity(
                opacity: _waveAnimations[index].value,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
