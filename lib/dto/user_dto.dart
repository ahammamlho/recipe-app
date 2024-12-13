class UserDTO {
  final String uuid;
  final String fullName;
  final String userName;
  final String email;
  final String avatarUrl;
  final String socialMediaUrl;
  final String bio;
  final int score;

  final int numberRecipes;
  final int viewsProfile;
  final int numberFollowers;
  final String status;

  UserDTO({
    required this.uuid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.avatarUrl,
    required this.socialMediaUrl,
    required this.bio,
    required this.score,
    required this.numberFollowers,
    required this.numberRecipes,
    required this.viewsProfile,
    required this.status,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      uuid: json['uuid'],
      fullName: json['full_name'],
      userName: json['user_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      socialMediaUrl: json['social_media_link'],
      bio: json['bio'],
      score: json['score'],
      numberFollowers: json['number_followers'],
      numberRecipes: json['number_recipes'],
      viewsProfile: json['views_profile'],
      status: json['status'],
    );
  }

  // Method to convert a UserDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'full_name': fullName,
      'user_name': userName,
      'email': email,
      'avatar_url': avatarUrl,
      'social_media_link': socialMediaUrl,
      'bio': bio,
      'score': score,
      "number_followers": numberFollowers,
      "number_recipes": numberRecipes,
      "views_profile": viewsProfile,
      "status": status,
    };
  }
}
