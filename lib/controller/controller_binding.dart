import 'package:desactvapp3/controller/user_subscription_controller.dart';
import 'package:get/get.dart';
import 'login.dart';

class MyBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<UserSubController>(() => UserSubController());
  }

}