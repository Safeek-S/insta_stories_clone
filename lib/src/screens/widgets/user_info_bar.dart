import 'package:flutter/material.dart';
import 'package:instastoriesclone/src/screens/widgets/story_timeline_bar.dart';

import '../../models/user_model.dart';

class UserInfoBar extends StatelessWidget {
final List<User> users;
final User currentUser;
 final int currentUserIndex;
  final int currentStoryIndex;
  final AnimationController animController;
  const UserInfoBar(this.users,this.currentUser,this.currentUserIndex,this.currentStoryIndex,this.animController);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.0,
      left: 10.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: List.generate(
              users[currentUserIndex].stories.length,
              (index) => AnimatedBar(
                animController: animController,
                position: index,
                currentUserIndex: currentUserIndex,
                currentStoryIndex: currentStoryIndex,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(currentUser.userImage),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      currentUser.userId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      currentUser.postedTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_horiz,
                size: 20,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
