import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desactvapp3/screens/home.dart';
import 'package:desactvapp3/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:desactvapp3/services/db_ops.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _countryValue = "Country *";
  bool obscure = true;
  String phone = "";

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String responseProcess = "Please wait...";
  @override
  void initState() {
    DBOPS dbops = DBOPS();
    super.initState();
  }

  Future<String?> getPhoneFromFirestore(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data();

        if (userData != null && userData.containsKey('phone')) {
          return phone = userData['phone'].toString();
        }
      }
    } catch (e) {
      print('Error retrieving phone value: $e');
    }

    return null;
  }

  Future<void> signIn(BuildContext context) async {
    try {
      // Get the user document with the provided username
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await usersCollection.where('username', isEqualTo: username.text).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Username exists, retrieve the user's email address
        final userDoc = querySnapshot.docs.first;
        final userEmail = userDoc['email'];

        // Show a loading dialog
        showLoadingDialog("Signing In...");

        // Sign in the user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: password.text,
        );

        // Get the user ID (UID)
        String userId = userCredential.user!.uid;

        // Save user ID (UID) to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
        GetStorage().write('userId', phone);

        // Close the loading dialog
        Navigator.pop(context);

        // Show a success dialog
        showResponseDialog("Sign In successful!");

        // Sign in successful, navigate to home page or display a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Username does not exist, display an error message
        showResponseDialog("Username not found. Please check your username.");
      }
    } catch (e) {
      // Sign in failed, display an error message
      showResponseDialog("Sign In failed!\nInfo: $e");
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
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/de.png"),
                    ),
                  ),
                ),
                 Container(
                   height: Get.height-130,
                   padding:const EdgeInsets.symmetric(vertical:50),
                   decoration: BoxDecoration(
                     color: Colors.blueGrey.shade800,
                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                   ),
                   child: Column(
                     children: [
                       Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextField(
                                controller: username,
                                style: const TextStyle(
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(

                                  labelStyle: TextStyle(
                                      color: Colors.blueGrey.shade50
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                  label: const Text("username *"),
                                  border: const OutlineInputBorder(
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
                                  contentPadding:const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                                  label:const Text("Password *"),
                                  /* prefixIcon: Icon(Icons.password,size: 16,),*/
                                  border:const OutlineInputBorder(
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
                        margin:const EdgeInsets.only(top: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: (){
                              Get.to(()=> const RegisterScreen());
                              },
                              child: SizedBox(
                                child: Center(
                                    child: Text(
                                      "REGISTER",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )
                                ),
                                width: 90,),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green)
                              )
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("or",style: TextStyle(color: Colors.blueGrey),

                              ),
                            ),
                           ElevatedButton(
                               onPressed: () async{

                                  if(username.text==""||password.text==""){
                                    Get.snackbar("Error","",messageText: Text("Fill all the fields!",style:TextStyle(color: Colors.red,fontSize: 16)),icon: Icon(Icons.info_outline,color: Colors.red,));
                                  }else{
                                    signIn(context);
                                  }
                                },
                             child: SizedBox(
                               child: Center(
                                   child: Text(
                                       "LOGIN",
                                       style: TextStyle(
                                           color: Colors.white)
                                   )
                               ),
                               width: 90,),
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
