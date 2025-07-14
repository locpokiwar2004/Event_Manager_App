import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedBannerWidget extends StatefulWidget {
  final List<BannerItem> bannerItems;
  final Duration autoPlayDuration;
  final Duration animationDuration;

  const AnimatedBannerWidget({
    Key? key,
    required this.bannerItems,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _AnimatedBannerWidgetState createState() => _AnimatedBannerWidgetState();
}

class _AnimatedBannerWidgetState extends State<AnimatedBannerWidget> 
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _startAutoPlay();
    _animationController.forward();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_currentIndex < widget.bannerItems.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      
      _animationController.reset();
      _animationController.forward();
      
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image Slider
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              itemCount: widget.bannerItems.length,
              itemBuilder: (context, index) {
                return _buildBannerItem(widget.bannerItems[index]);
              },
            ),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            
            // Content
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.bannerItems[_currentIndex].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.bannerItems[_currentIndex].subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.bannerItems[_currentIndex].description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Page Indicators
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.bannerItems.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: index == _currentIndex ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index == _currentIndex 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerItem(BannerItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: item.backgroundGradient ?? LinearGradient(
          colors: [
            item.primaryColor.withOpacity(0.8),
            item.secondaryColor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: item.backgroundImage != null
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item.backgroundImage!),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  item.primaryColor,
                  item.secondaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _buildBackgroundPattern(),
          ),
    );
  }

  Widget _buildBackgroundPattern() {
    return CustomPaint(
      painter: BannerPatternPainter(),
      size: Size.infinite,
    );
  }
}

class BannerItem {
  final String title;
  final String subtitle;
  final String description;
  final String? backgroundImage;
  final Color primaryColor;
  final Color secondaryColor;
  final Gradient? backgroundGradient;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.description,
    this.backgroundImage,
    this.primaryColor = Colors.orange,
    this.secondaryColor = Colors.deepOrange,
    this.backgroundGradient,
  });
}

class BannerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Draw decorative circles
    for (int i = 0; i < 6; i++) {
      final x = (size.width * 0.8) + (i * 30);
      final y = (size.height * 0.2) + (i * 25);
      canvas.drawCircle(Offset(x, y), 15 + (i * 2), paint);
    }
    
    // Draw wave pattern
    path.moveTo(size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 0.5,
      size.width, size.height * 0.7,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
