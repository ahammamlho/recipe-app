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
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      recipeUrl: json['recipe_url'],
      timer: json['timer'],
      numberLikes: json['number_likes'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'uuid_user': uuidUser,
      'title_recipe': titleRecipe,
      'ingredients': '[${ingredients.map((e) => '"$e"').join(', ')}]',
      'steps': '[${steps.map((e) => '"$e"').join(', ')}]',
      'recipe_url': recipeUrl,
      'timer': timer,
      'number_likes': numberLikes,
      "tags": '[${tags.map((e) => '"$e"').join(', ')}]',
    };
  }
}
