import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {
  final widgetWidth, widgetHeight;
  final Widget Function() widget;
  final int indexWidget;

  const DetailWidget({required this.widgetWidth, required this.widgetHeight, required this.widget, required this.indexWidget});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          final inAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: inAnimation, child: child);
        },
        child: Container(
            key: ValueKey<int>(widget.indexWidget),
            width: widget.widgetWidth,
            height: widget.widgetHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: widget.widget(),
        ),
      ),
      tag: 'my-hero-widget${widget.indexWidget}',
    );
  }
}
