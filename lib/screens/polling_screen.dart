import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'nominees.dart';

class PollingScreen extends StatefulWidget {
  const PollingScreen({Key? key}) : super(key: key);

  @override
  State<PollingScreen> createState() => _PollingScreenState();
}

class _PollingScreenState extends State<PollingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("AWARDS",style: TextStyle(fontSize: 18),),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/awards_back.jpg"),
              fit: BoxFit.cover
            )
          ),

          child: Container(
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: ()=>Get.to(()=>Nominees("MAC AWARDS"),transition: Transition.native),
                          child: Card(
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/des.png",width:100),
                                  SizedBox(height: 15,),
                                  Text("MUFULIRA GOT TALENT")
                                ],
                              ),
                            ),
                          ),
                        ),
                          SizedBox(height: 15),
                           GestureDetector(
                                onTap: (){
                                Get.to(()=>Nominees("DESAC AWARDS"));
                                },
                                child: Card(
                                  elevation: 20,
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  "assets/des.png",
                                                ),
                                                radius: 50,
                                              ),
                                              SizedBox(height: 15,),
                                              Text("DESAC MUSIC AWARDS")
                                            ],
                                          ),
                                      ),
                                      ),
                                    ),
                                ),
                                SizedBox(height: 15),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>Nominees("DESAC TV GAMESHOW"));
                          },
                          child: Card(
                            elevation: 20,
                            child: Container(

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/cbc.png",
                                      ),
                                      radius: 50,
                                    ),
                                    SizedBox(height: 15,),
                                    Text("DESAC TV GAMESHOW")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height-56,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
