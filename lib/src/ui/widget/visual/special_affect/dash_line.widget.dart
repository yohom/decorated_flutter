import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  ///The height of the widget. Should be greater than 0 only for Axis.vertical.
  final double height;

  ///The width of the widget. Should be greater than 0 only for Axis.horizontal.
  final double width;

  ///Axis can only be either Axis.horizontal or Axis.vertical.
  final Axis axis;

  ///dashHeight default to 5. Use dashHeight with vertical axis.
  final double dashHeight;

  ///dashWidth default to 5. Use dashWidth with horizontal axis.
  final double dashWidth;

  ///The space between two dash. Defaults to 3.
  final double dashSpace;

  ///The thickness of a single dash. Defaults to 1.
  final double strokeWidth;

  ///The color of a dash. Defaults to black.
  final Color dashColor;

  final StrokeCap strokeCap;

  ///For Horizontal dash line declare width > 0 and height can be 0.

  ///For Vertical dash line declare height > 0 and width can be 0.

  ///Create a dashed line with given parameters.
  const DashedLine({
    super.key,
    required this.height,
    required this.width,
    required this.axis,
    this.dashHeight = 5,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1,
    this.strokeCap = StrokeCap.round,
    this.dashColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DashedLinePainter(
        axis: axis,
        dashHeight: dashHeight,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        dashColor: dashColor,
        strokeWidth: strokeWidth,
        strokeCap: strokeCap,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Axis axis;
  final double dashHeight, dashWidth, dashSpace, strokeWidth;
  final Color dashColor;
  final StrokeCap strokeCap;

  const DashedLinePainter({
    required this.axis,
    required this.dashHeight,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    required this.dashColor,
    required this.strokeCap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (axis == Axis.vertical) {
      double startY = 0;
      final paint = Paint()
        ..color = dashColor
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap;
      while (startY < size.height) {
        canvas.drawLine(
            Offset(0, startY), Offset(0, startY + dashHeight), paint);
        startY += dashHeight + dashSpace;
      }
    } else {
      double startX = 0;
      final paint = Paint()
        ..color = dashColor
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap;
      while (startX < size.width) {
        canvas.drawLine(
            Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
