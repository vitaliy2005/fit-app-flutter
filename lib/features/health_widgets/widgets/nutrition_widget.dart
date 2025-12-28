import 'dart:math';
import 'package:flutter/material.dart';


class _PieChartPainter extends CustomPainter {
  final double sliceFraction;
  final Color sliceColor;
  final Color backgroundColor;

  _PieChartPainter({
    required this.sliceFraction,
    required this.sliceColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintBg = Paint()..color = backgroundColor;
    final paintSlice = Paint()..color = sliceColor;
    final paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.brown.shade500;

    canvas.drawCircle(center, radius, paintBg);

    final startAngle = -pi / 2;
    final sweepAngle = sliceFraction * 2 * pi;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paintSlice);

    canvas.drawCircle(center, radius, paintBorder);

    final startPoint = Offset(
      center.dx + cos(startAngle) * radius,
      center.dy + sin(startAngle) * radius,
    );
    final endPoint = Offset(
      center.dx + cos(startAngle + sweepAngle) * radius,
      center.dy + sin(startAngle + sweepAngle) * radius,
    );
    canvas.drawLine(center, startPoint, paintBorder);
    canvas.drawLine(center, endPoint, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A labeled bar that ensures consistent left margin for alignment


class _AlignedLabeledBar extends StatelessWidget {
  const _AlignedLabeledBar({
    Key? key,
    required this.label,
    required this.fraction,
    required this.barColor,
    required this.backgroundColor, required this.fillWeightPercent,
  }) : super(key: key);

  final String label;
  final double fraction;
  final Color barColor;
  final Color backgroundColor;
  final double height = 20;
  final double fillWeightPercent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final fillWidth = constraints.maxWidth * fillWeightPercent;
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: height,
                width: fillWidth,
                // color: backgroundColor,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(128),
                  border: Border.all(color: Colors.brown.shade500, width: 3), // обводка бара
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(128),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
class NutritionStatsWidget extends StatelessWidget {
  const NutritionStatsWidget({
    Key? key,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.decoration,
  }) : super(key: key);

  final double calories;
  final double protein;
  final double fat;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: decoration,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: CustomPaint(
                painter: _PieChartPainter(
                  sliceFraction: calories,
                  sliceColor: Colors.deepOrange.shade300,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _AlignedLabeledBar(
            label: 'CALORIES',
            fraction: calories,
            barColor: Colors.orangeAccent.shade200,
            backgroundColor: Colors.grey.shade300,
            fillWeightPercent: 0.8,
          ),
          const SizedBox(height: 12),
          _AlignedLabeledBar(
            label: 'PROTEIN',
            fraction: protein,
            barColor: Colors.brown.shade300,
            backgroundColor: Colors.grey.shade300,
            fillWeightPercent: 0.5,
          ),
          const SizedBox(height: 12),
          _AlignedLabeledBar(
            label: 'FAT',
            fraction: fat,
            barColor: Colors.deepOrange.shade200,
            backgroundColor: Colors.grey.shade300,
            fillWeightPercent: 0.3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.local_pizza, size: 40, color: Colors.brown),
              SizedBox(width: 16),
              Icon(Icons.emoji_food_beverage, size: 40, color: Colors.green),
            ],
          ),
        ],
      ),
    );

    return child;
  }
}
