class RecipceDto {
  final String uuid;
  final String uuidUser;
  final String titleRecipe;
  final List<String> ingredients;
  final List<String> steps;
  final String recipeUrl;
  final double timer;
  final int numberLikes;
  final List<String> tags;

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
  });

  factory RecipceDto.fromJson(Map<String, dynamic> json) {
    return RecipceDto(
      uuid: json['uuid'],
      uuidUser: json['uuid_user'],
      titleRecipe: json['title_recipe'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      recipeUrl: json['recipe_url'],
      timer: json['timer'],
      numberLikes: json['number_likes'],
      tags: json['tags'],
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
