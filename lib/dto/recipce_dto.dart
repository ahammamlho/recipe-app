class RecipceDto {
  final String uuid;
  final String uuidUser;
  final String titleRecipe;
  final List<dynamic> ingredients;
  final List<dynamic> steps;
  final String recipeUrl;
  final double timer;
  int numberLikes;
  final List<dynamic> tags;
  bool isLikedByOwner;

  RecipceDto({
    required this.uuid,
    required this.uuidUser,
    required this.titleRecipe,
    required this.ingredients,
    required this.steps,
    required this.recipeUrl,
    required this.timer,
    required this.numberLikes,
    required this.tags,
    required this.isLikedByOwner,
  });

  factory RecipceDto.fromJson(Map<String, dynamic> json) {
    return RecipceDto(
      uuid: json['uuid'],
      uuidUser: json['uuid_user'],
      titleRecipe: json['title_recipe'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      recipeUrl: json['recipe_url'],
      timer: (json['timer']).toDouble(),
      numberLikes: json['number_likes'],
      tags: json['tags'],
      isLikedByOwner: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'uuid_user': uuidUser,
      'title_recipe': titleRecipe,
      'ingredients': ingredients,
      'steps': steps,
      'recipe_url': recipeUrl,
      'timer': timer,
      'number_likes': numberLikes,
      "tags": tags,
    };
  }
}
