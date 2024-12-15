class ReviewDto {
  final String uuid;
  String uuidUser;
  String uuidRecipe;
  double rate;
  String feedback;
  String imgUrl;
  DateTime createdAt;

  String userAvatar;
  String userName;

  ReviewDto({
    required this.uuid,
    required this.uuidUser,
    required this.uuidRecipe,
    required this.rate,
    required this.feedback,
    required this.imgUrl,
    required this.createdAt,
    required this.userAvatar,
    required this.userName,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
        uuid: json['uuid'],
        uuidUser: json['uuid_user'],
        uuidRecipe: json['uuid_recipe'],
        rate: json['rate'].toDouble(),
        feedback: json['feedback'],
        imgUrl: json['img_url'],
        createdAt: DateTime.parse(json['created_at']),
        userAvatar: json['user_avatar'] ?? "",
        userName: json['user_name'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'uuid_user': uuidUser,
      'uuid_recipe': uuidRecipe,
      'rate': rate,
      'feedback': feedback,
      'img_url': imgUrl,
      'created_at': createdAt.toIso8601String(),
      "user_avatar": userAvatar,
      "user_name": userName
    };
  }
}
