import 'package:get/get.dart';
import 'package:recipe/screens/add_recipe.dart';
import 'package:recipe/screens/page_home.dart';

class MyController extends GetxController {
  int index = 2;

  void changeIndex(int i) {
    index = i;
    if (index == 0) {
      Get.off(const AddRecipe());
    }
    if (index == 2) {
      Get.off(const PageHome());
    }
    // update();
  }
}
