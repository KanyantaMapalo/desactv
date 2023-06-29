import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desactvapp3/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:desactvapp3/services/db_ops.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _countryValue = "Country *";
  bool obscure = true;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referrercode = TextEditingController();
  TextEditingController promocode = TextEditingController();

  DBOPS dbops = DBOPS();

  String responseProcess = "Please wait...";
  @override
  void initState() {
    DBOPS dbops = DBOPS();

    super.initState();
  }

  Future<bool> checkUsernameAvailability(String username) async {
    // Assuming you have a Firestore collection named 'users' that stores user information
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Query Firestore to check if the username already exists
    final querySnapshot = await usersCollection.where('username', isEqualTo: username).get();

    // Return true if the username exists (already taken), false otherwise
    return querySnapshot.docs.isNotEmpty;
  }


  Future<void> registerAccount(BuildContext context) async {
    try {
      // Check if the username is already taken
      bool isUsernameTaken = await checkUsernameAvailability(username.text);

      if (isUsernameTaken) {
        // Username is already taken, display an error message
        showResponseDialog("Username is already taken. Please choose a different username.");
      } else {
        // Show a loading dialog
        showLoadingDialog("Please wait");

        // Create the user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        // Get the user ID (UID)
        String userId = userCredential.user!.uid;

        // Save user ID (UID) to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstname': firstname.text,
          'lastname': lastname.text,
          'email': email.text,
          'phone': phone.text,
          'country': _countryValue,
          'username': username.text,
          'referrer_code': referrercode.text,
          'promo_code': promocode.text,
        });

        // Close the loading dialog
        Navigator.pop(context);

        // Show a success dialog
        showResponseDialog("Registration successful!");

        // Registration successful, navigate to home page or display a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      // Registration failed, display an error message
      showResponseDialog("Registration failed!\nInfo: $e");
    }
  }

  void showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
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
                  Text(message),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showResponseDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            elevation: 20,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 200,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/de.png"),
                  ),
                ),
              ),
              Card(
                color: Colors.white70,
                elevation: 20,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: firstname,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "First Name *",
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.brown,
                            )
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 25,),
                      TextField(
                        controller: lastname,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "Last Name *",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 25,),
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "Email *",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          prefixIcon: Icon(Icons.alternate_email,size: 16,),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 25,),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: phone,
                        style: const TextStyle(
                          color: Colors.black87
                        ),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("Phone"),
                          prefixIcon: Icon(Icons.phone,size: 16,),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                      ),
      Container(
        margin: const EdgeInsets.only(top:25),
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: const Border(
              top: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              right: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              bottom: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              left: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white)
          )
        ),
        child: DropdownButton(
          dropdownColor: Colors.white,
          icon: const Icon(Icons.location_on),
          hint: _countryValue == null
              ? const Text('Dropdown')
              : Text(
            _countryValue,
            style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
          ),
          isExpanded: true,
          iconSize: 30.0,
          style: const TextStyle(color: Colors.black87),
          items: ['Angola', 'Congo', 'Zambia', 'Zimbabwe'].map((val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Column(
                  children: [
                    Row(
                      children: [
                        /*Image.asset("assets/zm.png"),*/
                        Container(child: Text(val),padding: const EdgeInsets.only(left: 10),),
                      ],
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onChanged: (val) {
            setState(
                  () {
                    print(val);
                _countryValue = val!;
              },
            );
          },
        ),
      ),
                      const SizedBox(height: 25,),
                      TextField(
                        controller: username,
                        style: const TextStyle(
                            color: Colors.black87
                        ),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "Username *",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 25,),
                      TextField(
                        controller: password,
                        obscureText: obscure,
                        style: const TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(

                          suffixIcon: IconButton(onPressed: (){setState(() {
                            obscure?obscure=false:obscure=true;
                          });},icon: Icon(obscure?Icons.remove_red_eye:Icons.visibility_off),),
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                          label: Text("Password *"),
                         /* prefixIcon: Icon(Icons.password,size: 16,),*/
                          border: const OutlineInputBorder(
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
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white60,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: referrercode,
                        style: const TextStyle(
                            color: Colors.black87
                        ),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "Referrer Code",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextField(
                        controller: promocode,
                        style: const TextStyle(
                            color: Colors.black87
                        ),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text(
                              "Your Promo Code",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
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
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   ElevatedButton(onPressed: (){}, child: const SizedBox(child: Center(child: Text("LOGIN")),width: 90,)),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("or"),
                  ),
                  ElevatedButton(onPressed: () async{

                    if(firstname.text==""||lastname.text==""||email.text==""||_countryValue==""||username.text==""||password.text==""){
                      Get.snackbar("Error","",messageText: Text("Fill all the fields!",style:TextStyle(color: Colors.red,fontSize: 16)),icon: Icon(Icons.info_outline,color: Colors.red,));
                    }else{
                      //create account
                      registerAccount(context);
                    }
                  }, child: SizedBox(child: Center(child: Text("REGISTER")),width: 90,))
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
