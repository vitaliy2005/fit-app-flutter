import 'package:flutter/material.dart';

import '../view/nutrition_detail_screen.dart';

class Carousel extends StatefulWidget {
  final int itemCount;
  final Map<int, Widget Function()> listWidgets;
  final Widget Function(BuildContext, int)? itemBuilder;

  Carousel({
    Key? key, required this.itemCount, this.itemBuilder, required this.listWidgets,
  }) : super(key : key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentPage = 0;
  final _pageController = PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 444,
          child: PageView.builder(
              controller: _pageController,
              itemBuilder:(context, index) {
                return Container(
                  child: GestureDetector(
                    child: Hero(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: widget.listWidgets[index]!(),
                      ),
                      tag: 'my-hero-widget$index',
                    ),
                    onTap: () async {
                      final newIndex = await Navigator.push<int>(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          reverseTransitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              PlantDetailPage(startIndexWidget: index),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                            final scale = Tween(begin: 0.5, end: 1.0).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                            return FadeTransition(
                              opacity: fade,
                              child: ScaleTransition(scale: scale, child: child),
                            );
                          },
                        ),
                      );
                      if (newIndex != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && _pageController.hasClients) {
                            _pageController.jumpToPage(newIndex);
                            setState(() => _currentPage = newIndex);
                          }
                        });
                      }
                    }
                  ),
                  margin: const EdgeInsets.only(
                      right: 8,
                      left: 8,
                      top: 24,
                      bottom: 12
                  ),
                );
              },
              onPageChanged: (value) {
                setState(() => _currentPage = value);
              },
            itemCount: widget.itemCount,
          ),
        ),
        SizedBox(
          height: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.itemCount, (i) => Icon(Icons.circle, size: 12, color: (i == _currentPage) ? Colors.blue.shade500 : Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }
}
