
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import 'hexagon_container.dart';


class CarouselView extends StatefulWidget {
  final PageController controller; // Controller for managing the page view
  final int selectedIndex; // Index of the currently selected user
  final Function(int) onPageChanged; // Callback for page change events
  final List<User> users; // List of users to display in the carousel

  // Constructor for initializing the CarouselView with required parameters
  const CarouselView({
    required this.controller,
    required this.selectedIndex,
    required this.onPageChanged,
    required this.users,
  });

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controller for animations
  late Animation<Offset> _slideAnimation; // Animation for sliding effect

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController for controlling animation duration and vsync
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Duration of the slide animation
      vsync: this, // Use this ticker provider for animations
    );

    // Define slide animation from right to left
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start position (off-screen right)
      end: Offset.zero, // End position (normal position)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInSine, // Smooth curve for the slide animation
    ));

    // Start the animation when the widget is first built
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant CarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart the animation if the selected index changes
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _animationController.reset(); // Reset animation to the beginning
      _animationController.forward(); // Start the animation
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, // Position the carousel view at the bottom of the screen
      width: MediaQuery.of(context).size.width, // Full width of the screen
      height: 220, // Fixed height for the carousel view
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur effect for the background
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Padding around the container
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements evenly
              children: [
                SizedBox(
                  height: 140, // Height for the image carousel
                  child: PageView.builder(
                    controller: widget.controller, // PageController for managing pages
                    itemCount: widget.users.length, // Number of pages equal to the number of users
                    onPageChanged: widget.onPageChanged, // Callback for page change
                    itemBuilder: (context, index) {
                      // Determine if the current page is selected
                      bool isSelected = index == widget.selectedIndex;
                      double scale = isSelected ? 0.8 : 0.5; // Scale factor for selected and non-selected users

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5), // Padding between images
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 350), // Duration for the scale animation
                          tween: Tween<double>(begin: scale, end: scale), // Tween for scaling
                          curve: Curves.easeInOut, // Curve for animation
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value, // Apply scale transformation
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle, // Circle shape for the user avatar
                                          gradient: isSelected
                                              ? const LinearGradient(
                                                  colors: [Colors.pink, Colors.purple],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                              : null, // Gradient for selected user
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0), // Stroke around the avatar
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                widget.users[index].userImage), // User image
                                            radius: 50, // Radius of the avatar
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.9), // Background for the emoji
                                            ),
                                            child: Text(
                                              widget.users[index].emojiString, // Emoji of the selected user
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10), // Padding between avatar and text
                                    child: Text(
                                      '@${widget.users[index].userId}', // User ID text
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SlideTransition(
                  position: _slideAnimation, // Apply slide animation
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements evenly
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
                        children: [
                          Text(
                            widget.users[widget.selectedIndex].storyText, // Story text for the selected user
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 10), // Space between story text and liked by row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const HexagonWithIcon(), // Placeholder for additional UI element
                              const SizedBox(width: 3),
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  widget.users[widget.selectedIndex].likedByPersonImage,
                                ), // Image of the person who liked the story
                                radius: 10, // Radius of the avatar
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Liked by ${widget.users[widget.selectedIndex].likedByPersonId}', // Text showing who liked the story
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.more_horiz, // Icon for more options
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
