import '../models/user_model.dart';

List<User> users = [
  User(
      id: 1,
      userId: "brad_pitt",
      storyText: "This scenaries are 🔥🔥",
      likedByPersonId: "_jessica_",
      label: "",
      stories: [
        "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4",
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4",
        "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4",
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4"
      ],
      userImage: 'lib/src/assets/images/brad.jpg',
      likedByPersonImage: 'lib/src/assets/images/jessica.jpg',
      emojiString: '🤙🏼',
      postedTime: '47m'),
  User(
      id: 2,
      userId: "_jessica_",
      storyText:  "Enjoyed day out there 😇",
      likedByPersonId: "_cruise_.tom_",
      label: "",
      stories: [
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4",
        "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4",
      ],
      userImage: 'lib/src/assets/images/jessica.jpg',
      likedByPersonImage: 'lib/src/assets/images/tom.jpg',
      emojiString: '🌴',
      postedTime: '58m'),
        User(
      id: 3,
      userId: "_cruise_.tom_",
      storyText: "Perfect location for my next stunts.... ",
      likedByPersonId: "brad_pitt",
      label: "",
      stories: [
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4",
        "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4",
      ],
      userImage: 'lib/src/assets/images/tom.jpg',
      likedByPersonImage: 'lib/src/assets/images/brad.jpg',
      emojiString: '💥',
      postedTime: '2h'),
       User(
      id: 3,
      userId: "_lea_seydoux",
      storyText: "Perfect Destination ✌🏼🍃",
      likedByPersonId: "_cruise_.tom_",
      label: "",
      stories: [
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4",
        "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4",
      ],
      userImage: 'lib/src/assets/images/lea.jpg',
      likedByPersonImage: 'lib/src/assets/images/tom.jpg',
      emojiString: '🌊',
      postedTime: '2h'),
];
