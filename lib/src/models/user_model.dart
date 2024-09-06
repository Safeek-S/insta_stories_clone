class User {
  int id;
  String userImage;
  String likedByPersonImage;
  String userId;
  String storyText;
  String likedByPersonId;
  String label;
  List<String> stories;
  String emojiString;
  String postedTime;
  User({
    required this.id,
    required this.userId,
    required this.storyText,
    required this.likedByPersonId,
    required this.label,
    required this.stories,
    required this.userImage,
    required this.likedByPersonImage,
    required this.emojiString,
    required this.postedTime,
  });
}
