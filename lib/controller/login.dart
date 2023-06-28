import 'dart:convert';

import 'package:desactvapp3/models/user_hive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../screens/home.dart';

class LoginController extends GetxController{
  
  var userdets = <User>[].obs;

  @override
  void onInit(){
    super.onInit();
  }

  Future<String>login(username,password)async{
    List<User> userFetched = [];
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/login.php"),body: {"username":username,"password":password});
    var jsoned = json.decode(response.body);

    User user = User(jsoned["user"][0]["firstname"], jsoned["user"][0]["lastname"], jsoned["user"][0]["email"], jsoned["user"][0]["phone"], jsoned["user"][0]["country"],jsoned["user"][0]["userID"].toString());
    userFetched.add(user);

    userdets.value = userFetched;
    if(jsoned["user"][0]["responseCode"]==1){
      Get.offAll(()=>HomeScreen());
    }else{
      Get.defaultDialog(title: "Error:",content: Text("Incorrect Username or Password!"));
    }

    print(username);
    return "1";
  }


}