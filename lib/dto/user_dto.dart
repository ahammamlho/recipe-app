class UserDTO {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String socialMediaUrl;
  final int score;

  UserDTO({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.socialMediaUrl,
    required this.score,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      socialMediaUrl: json['socialMediaUrl'],
      score: json['score'],
    );
  }

  // Method to convert a UserDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'socialMediaUrl': socialMediaUrl,
      'score': score,
    };
  }
}
