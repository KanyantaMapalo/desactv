import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 2),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Text("Personal Details:",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Text("First Name:",style:TextStyle(fontWeight: FontWeight.bold)),
                                Text(GetStorage().read('firstname'))
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("Last Name:",style:TextStyle(fontWeight: FontWeight.bold)),
                                Text(GetStorage().read('lastname'))
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("Email:",style:TextStyle(fontWeight: FontWeight.bold)),
                                Text(GetStorage().read('email'))
                              ]
                            ),
                            TableRow(
                              children: [
                                Text("Phone Number:",style:TextStyle(fontWeight: FontWeight.bold)),
                                Text(GetStorage().read('phone'))
                              ]
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Text("System Access Details:",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        Container(height: 0.5,color: Colors.grey,),
                        Column(
                          children: [
                            Row(
                              children: [
                                TextButton(onPressed: (){}, child: Text("Change Password"))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Text("Promotion",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        Container(height: 0.5,color: Colors.grey,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Container(
                                child: Text("Promo code: "),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10)

                              ),
                                child: Row(
                                  children: [
                                    Text("KaluChaks",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    IconButton(onPressed: ()async{
                                      Fluttertoast.showToast(
                                          msg: "Copied to Clipboard",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 13.0
                                      );
                                      await Clipboard.setData(ClipboardData(text: "KaluChaks"));


                                    }, icon: Icon(Icons.copy))
                                  ],
                                ),
                              )
                            ]
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white38
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Earnings:", style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,fontSize: 16),),
                              Table(
                                children: [
                                  TableRow(
                                    children: [
                                      Text("Referrals:"),
                                      Text("29 Points",style: TextStyle(fontWeight: FontWeight.bold),)
                                    ]
                                  ),
                                  TableRow(
                                      children: [
                                        Text("Watch time:"),
                                        Text("10 Points",style: TextStyle(fontWeight: FontWeight.bold),)
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        Text("Total:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                        Text("39 Points",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        Text(""),
                                        ElevatedButton(onPressed: (){}, child: Text("Redeem"))
                                      ]
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                       
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
