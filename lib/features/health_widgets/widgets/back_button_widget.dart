import 'package:flutter/material.dart';

class BackButtonCustom extends StatelessWidget {
  final int? returnIndex;
  const BackButtonCustom({super.key, required this.returnIndex});

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).maybePop(returnIndex),
      child: const SizedBox(
        width: 58,
        height: 58,
        child: Icon(Icons.arrow_back, color: Colors.black87),
      ),
    );
    // return Material(
    //   color: Colors.white,
    //   borderRadius: BorderRadius.circular(12),
    //   elevation: 4,
    //   child: InkWell(
    //     borderRadius: BorderRadius.circular(12),
    //     onTap: () => Navigator.of(context).maybePop(returnIndex),
    //     child: const SizedBox(
    //       width: 58,
    //       height: 58,
    //       child: const Icon(Icons.arrow_back, color: Colors.black87),
    //     ),
    //   ),
    // );
    return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 28,
              spreadRadius: -6,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: child,
      );
    }
}