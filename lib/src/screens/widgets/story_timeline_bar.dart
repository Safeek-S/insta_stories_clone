import 'package:flutter/material.dart';

class AnimatedBar extends StatelessWidget {
  final AnimationController animController; // Controller for handling animation
  final int position; // Position of the bar in the list
  final int currentUserIndex; // Index of the current user
  final int currentStoryIndex; // Index of the current story

  // Constructor for initializing AnimatedBar with required parameters
  const AnimatedBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentUserIndex,
    required this.currentStoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5), // Padding between bars
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                // Build the background container for the bar
                _buildContainer(
                  double.infinity, // Full width for the background
                  position < currentStoryIndex
                      ? Colors.white // Color for completed stories
                      : Colors.white.withOpacity(0.5), // Color for upcoming stories
                ),
                // Build the animated container if this is the current story
                position == currentStoryIndex
                    ? AnimatedBuilder(
                        animation: animController, // Animation controller
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value, // Width based on animation value
                            Colors.white, // Color for the animated part
                          );
                        },
                      )
                    : const SizedBox.shrink(), // Empty widget if not the current story
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper method to create a container with a specific width and color
  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0, // Height of the bar
      width: width, // Width of the bar (animated or static)
      decoration: BoxDecoration(
        color: color, // Background color of the bar
        border: Border.all(
          color: Colors.black26, // Border color
          width: 0.8, // Border width
        ),
        borderRadius: BorderRadius.circular(3.0), // Rounded corners
      ),
    );
  }
}
