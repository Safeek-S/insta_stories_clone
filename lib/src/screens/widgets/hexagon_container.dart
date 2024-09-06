import 'package:flutter/material.dart';

class HexagonWithIcon extends StatelessWidget {
  // Constructor for HexagonWithIcon widget
  const HexagonWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(13, 13), // Size of the hexagon
      painter: HexagonPainter(), // Custom painter for drawing the hexagon
      child: Container(
        padding: const EdgeInsets.all(3), // Padding inside the hexagon
        child: const Center(
          child: Icon(
            Icons.done, // Icon to be displayed inside the hexagon
            size: 8, // Size of the icon
            color: Colors.white, // Color of the icon
          ),
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object for drawing the hexagon
    final Paint paint = Paint()
      ..color = Colors.transparent // Set fill color to transparent
      ..style = PaintingStyle.stroke // Draw only the border of the hexagon
      ..strokeWidth = 1 // Set the width of the border
      ..color = Colors.white; // Set the color of the border

    // Define the path for the hexagon shape
    final Path hexagonPath = Path();
    final double width = size.width;
    final double height = size.height;

    // Move to the top center of the hexagon
    hexagonPath.moveTo(width * 0.5, 0);
    // Draw lines to each vertex of the hexagon
    hexagonPath.lineTo(width, height * 0.25);
    hexagonPath.lineTo(width, height * 0.75);
    hexagonPath.lineTo(width * 0.5, height);
    hexagonPath.lineTo(0, height * 0.75);
    hexagonPath.lineTo(0, height * 0.25);
    hexagonPath.close(); // Close the path to complete the hexagon shape

    // Draw the hexagon on the canvas with the defined paint
    canvas.drawPath(hexagonPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Return false as the hexagon does not need to repaint
    return false;
  }
}
