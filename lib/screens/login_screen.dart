import 'dart:convert';

import 'package:desactvapp3/screens/home.dart';
import 'package:desactvapp3/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:desactvapp3/services/db_ops.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/login.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _countryValue = "Country *";
  bool obscure = true;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  GetxController loginController = Get.put(LoginController());

  String responseProcess = "Please wait...";
  @override
  void initState() {
    DBOPS dbops = DBOPS();


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/de.png"),
                    ),
                  ),
                ),
                 Container(
                   height: Get.height-130,
                   padding: EdgeInsets.symmetric(vertical:50),
                   decoration: BoxDecoration(
                     color: Colors.blueGrey.shade800,
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                   ),
                   child: Column(
                     children: [
                       Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextField(
                                controller: username,
                                style: TextStyle(
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(

                                  labelStyle: TextStyle(
                                      color: Colors.blueGrey.shade50
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                  label: Text("Username *"),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.brown,
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(height: 25,),
                              TextField(
                                controller: password,
                                obscureText: obscure,
                                style: TextStyle(
                                    color: Colors.blueGrey.shade50
                                ),
                                decoration: InputDecoration(

                                  suffixIcon: IconButton(onPressed: (){setState(() {
                                    obscure?obscure=false:obscure=true;
                                  });},icon: Icon(obscure?Icons.remove_red_eye:Icons.visibility_off),),
                                  labelStyle: TextStyle(
                                      color: Colors.blueGrey.shade50
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                                  label: Text("Password *"),
                                  /* prefixIcon: Icon(Icons.password,size: 16,),*/
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.brown,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: (){
                              Get.to(()=>RegisterScreen());
                            }, child: SizedBox(child: Center(child: Text("REGISTER", style: TextStyle(color: Colors.white),)),width: 90,),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.green)
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("or",style: TextStyle(color: Colors.blueGrey),

                              ),
                            ),
                           ElevatedButton(
                               onPressed: () async{

                                  if(username.text==""||password.text==""){
                                    Get.snackbar("Error","",messageText: Text("Fill all the fields!",style:TextStyle(color: Colors.red,fontSize: 16)),icon: Icon(Icons.info_outline,color: Colors.red,));
                                  }else{
                                    responseProcess = "Please wait";
                                    showDialog(context: context, builder: (BuildContext context){
                                      return  Center(
                                        child: Card(
                                          elevation: 20,
                                          child: Container(
                                              padding: EdgeInsets.all(20),
                                              height: 200,
                                              width: 300,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 15,),
                                                  Text('$responseProcess'),
                                                ],
                                              )
                                          ),
                                        ),
                                      );

                                    });
                                    responseProcess = await Get.find<LoginController>().login(username.text, password.text);
                                    print(responseProcess);
                                  }
                                }, child: SizedBox(child: Center(child: Text("LOGIN", style: TextStyle(color: Colors.white))),width: 90,),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green)
                              ),
                           )

                          ],
                        ),),
                     ],
                   ),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
