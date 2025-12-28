import 'package:flutter/material.dart';

class SideIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const SideIconButton({required this.icon, required this.tooltip, required this.color, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Center(
            child: Tooltip(
              message: tooltip,
              child: Icon(icon, color: color, size: 35),
            ),
          ),
        ),
      ),
    );
  }
}
