import 'package:flutter/material.dart';
import 'package:instastoriesclone/src/screens/widgets/user_info_bar.dart';
import 'package:video_player/video_player.dart';

import '../models/user_model.dart';
import 'widgets/carousel_view.dart';

class StoryScreen extends StatefulWidget {
  final List<User> users; // List of users with their stories

  const StoryScreen({required this.users});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller; // Controller for video playback
  late PageController _pageController; // Controller for user page navigation
  late AnimationController _animController; // Controller for story animation
  late PageController _numberCarouselController; // Controller for the user carousel view
  int _currentUserIndex = 0; // Index of the currently selected user
  int _currentStoryIndex = 0; // Index of the currently playing story

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize page controller for user view
    _animController = AnimationController(vsync: this); // Initialize animation controller
    _numberCarouselController = PageController(viewportFraction: 0.35); // Initialize carousel controller

    // Load the first story for the initial user
    _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);

    // Add a listener to handle story playback completion and user transitions
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop(); // Stop the animation when completed
        _animController.reset(); // Reset the animation controller
        setState(() {
          if (_currentStoryIndex + 1 < widget.users[_currentUserIndex].stories.length) {
            _currentStoryIndex += 1; // Move to the next story within the same user
            _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex, animateToPage: false);
          } else {
            // Move to the next user after a delay if the current user has no more stories
            Future.delayed(const Duration(seconds: 1), () {
              if (_currentUserIndex + 1 < widget.users.length) {
                _currentUserIndex += 1; // Move to the next user
                _currentStoryIndex = 0; // Start from the first story of the new user
              } else {
                _currentUserIndex = 0; // Loop back to the first user
                _currentStoryIndex = 0; // Start from the first story
              }
              _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the video controller
    _pageController.dispose(); // Dispose of the page controller
    _animController.dispose(); // Dispose of the animation controller
    _numberCarouselController.dispose(); // Dispose of the carousel controller
    super.dispose();
  }

  // Method to load and play a story for a given user and story index
  void _loadStory({
    required int userIndex,
    required int storyIndex,
    bool animateToPage = true,
  }) {
    // Validate user index
    if (userIndex < 0 || userIndex >= widget.users.length) {
      print('Invalid user index: $userIndex');
      return;
    }

    // Validate story index
    if (storyIndex < 0 || storyIndex >= widget.users[userIndex].stories.length) {
      print('Invalid story index: $storyIndex for user $userIndex');
      return;
    }

    _animController.stop(); // Stop any ongoing animation
    _animController.reset(); // Reset animation controller

    // Dispose of the previous video controller if it exists
    _controller?.dispose();

    final storyUrl = widget.users[userIndex].stories[storyIndex];
    _controller = VideoPlayerController.networkUrl(Uri.parse(storyUrl))
      ..addListener(() {
        // Handle video playback errors
        if (_controller!.value.hasError) {
          print('Error with video: ${_controller!.value.errorDescription}');
        }
      })
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            if (_controller!.value.isInitialized) {
              _animController.duration = _controller!.value.duration;
              _controller!.play(); // Start video playback
              _animController.forward(); // Start animation
            }
          });
        }
      }).catchError((error) {
        print('Error initializing video controller: $error');
      });

    // Optionally animate to the user page if specified
    if (animateToPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(userIndex); // Jump to the user's page immediately
      });
    }
  }

  // Method to handle page changes in the user carousel
  void _onPageChanged(int index) {
    if (index < 0 || index >= widget.users.length) {
      print('Invalid user index: $index');
      return;
    }

    setState(() {
      _currentUserIndex = index; // Update the current user index
      _currentStoryIndex = 0; // Reset story index for the new user
    });

    // Synchronize the carousel and page view controllers
    _numberCarouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Load the first story of the newly selected user
    _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
  }

  // Method to handle tap interactions for story navigation and playback control
  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        // Handle left swipe for previous story or user
        if (_currentStoryIndex > 0) {
          _currentStoryIndex -= 1;
          _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
        } else if (_currentUserIndex > 0) {
          _currentUserIndex -= 1;
          _currentStoryIndex = widget.users[_currentUserIndex].stories.length - 1;
          _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        // Handle right swipe for next story or user
        if (_currentStoryIndex + 1 < widget.users[_currentUserIndex].stories.length) {
          _currentStoryIndex += 1;
          _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
        } else if (_currentUserIndex + 1 < widget.users.length) {
          _currentUserIndex += 1;
          _currentStoryIndex = 0;
          _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
        } else {
          _currentUserIndex = 0; // Loop back to the first user
          _currentStoryIndex = 0; // Start from the first story
          _loadStory(userIndex: _currentUserIndex, storyIndex: _currentStoryIndex);
        }
      });
    } else {
      // Handle tap to play or pause the story
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _animController.stop();
      } else {
        _controller!.play();
        _animController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = widget.users[_currentUserIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures for PageView
              itemCount: widget.users.length,
              itemBuilder: (context, i) {
                return FutureBuilder(
                  future: _controller?.initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller!.value.size.width,
                            height: _controller!.value.size.height,
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
            UserInfoBar(widget.users, currentUser, _currentUserIndex,
                _currentStoryIndex, _animController),
            CarouselView(
              controller: _numberCarouselController,
              selectedIndex: _currentUserIndex,
              onPageChanged: _onPageChanged,
              users: widget.users,
            ),
          ],
        ),
      ),
    );
  }
}
