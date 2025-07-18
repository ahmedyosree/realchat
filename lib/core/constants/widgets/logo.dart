import 'package:flutter/material.dart';

class AutoCrossFadeLogos extends StatefulWidget {
  const AutoCrossFadeLogos({super.key});

  @override
  State<AutoCrossFadeLogos> createState() => _AutoCrossFadeLogosState();
}

class _AutoCrossFadeLogosState extends State<AutoCrossFadeLogos>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // fadeIn goes 0→1 then back 1→0
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    // fadeOut is the inverse: 1→0 then 0→1
    _fadeOut = Tween(begin: 1.0, end: 0.0).animate(_fadeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return LayoutBuilder(builder: (context, constraints) {
      final maxLogoWidth = isLargeScreen
          ? constraints.maxWidth * 0.4   // up to 40% on large screens
          : constraints.maxWidth * 0.6;  // up to 60% on small screens

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxLogoWidth,
            maxHeight: 150,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity: _fadeOut,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              FadeTransition(
                opacity: _fadeIn,
                child: Image.asset(
                  'assets/logo_alt.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
