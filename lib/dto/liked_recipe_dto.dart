class LikedRecipeDto {
  final String uuid;
  final String uuidUser;
  final String uuidRecipe;

  LikedRecipeDto(
      {required this.uuid, required this.uuidUser, required this.uuidRecipe});

  factory LikedRecipeDto.fromJson(Map<String, dynamic> json) {
    return LikedRecipeDto(
      uuid: json['uuid'],
      uuidUser: json['uuid_user'],
      uuidRecipe: json['uuid_recipe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'uuid_user': uuidUser,
      'uuid_recipe': uuidRecipe,
    };
  }
}
