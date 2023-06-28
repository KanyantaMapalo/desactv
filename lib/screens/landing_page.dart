import 'package:flutter/material.dart';

import 'home.dart';
import 'login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/desactv.png"),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(75.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("WELCOME",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 30),),
                ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.red),

                  ),
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                }, child: Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
