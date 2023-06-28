import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user_subscription.dart';
import 'package:get_storage/get_storage.dart';

  class UserSubController extends GetxController{
    var usersubdetails = <UserSubscription>[].obs;
    final paymentOpt = ''.obs;

    @override
    void onInit() {
      super.onInit();
      // Read initial value from GetStorage
      paymentOpt.value = GetStorage().read('payermodeid') ?? '';

      // Run a GetxWorker to listen for changes in GetStorage
      ever<String>(paymentOpt, updatePayermodeid);
    }

    void updatePayermodeid(String payermodeid) {
      GetStorage().write('payermodeid', payermodeid);
    }


    Future<String> getUserSub(userid) async{
      var response = await http.post(Uri.parse("https://desaczm.com/app_backend/user_details.php"),body: {"user_id":userid});
      List<UserSubscription> list = [];

      var jsoned = json.decode(response.body);
      UserSubscription usersub = UserSubscription(jsoned["user"][0]["plan"].toString(), jsoned["user"][0]["watchdays"].toString(), jsoned["user"][0]["status"].toString(), jsoned["user"][0]["expiry_date"].toString());
      list.add(usersub);
      usersubdetails.value = list;
      return "";
    }




  }