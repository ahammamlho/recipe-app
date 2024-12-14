import 'package:get/get.dart';

class MyController extends GetxController {
  String uuidUser = "tr";
  MyController() {
    print(" --------------------------- called");
  }

  void changeUuidUser(String uuid) {
    print(" --------------------------- uuid = $uuid");
    uuidUser = uuid;
  }
}
