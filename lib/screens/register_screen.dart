import 'dart:convert';

import 'package:desactvapp3/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:desactvapp3/services/db_ops.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


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
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: firstname,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("First Name *"),
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
                        controller: lastname,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("Last Name *"),
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
                        controller: email,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("Email *"),
                          prefixIcon: Icon(Icons.alternate_email,size: 16,),
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
                        keyboardType: TextInputType.number,
                        controller: phone,
                        style: TextStyle(
                          color: Colors.black87
                        ),
                        decoration: InputDecoration(
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
        margin: EdgeInsets.only(top:25),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border(
              top: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              right: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              bottom: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white),
              left: BorderSide(style: BorderStyle.solid,width: .5,color: Colors.white)
          )
        ),
        child: DropdownButton(
          dropdownColor: Colors.white,
          icon: Icon(Icons.location_on),
          hint: _countryValue == null
              ? Text('Dropdown')
              : Text(
            _countryValue,
            style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
          ),
          isExpanded: true,
          iconSize: 30.0,
          style: TextStyle(color: Colors.black87),
          items: ['Angola', 'Congo', 'Zambia', 'Zimbabwe'].map((val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Column(
                  children: [
                    Row(
                      children: [
                        /*Image.asset("assets/zm.png"),*/
                        Container(child: Text(val),padding: EdgeInsets.only(left: 10),),
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
                      SizedBox(height: 25,),
                      TextField(
                        controller: username,
                        style: TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
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
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(

                          suffixIcon: IconButton(onPressed: (){setState(() {
                            obscure?obscure=false:obscure=true;
                          });},icon: Icon(obscure?Icons.remove_red_eye:Icons.visibility_off),),
                          labelStyle: TextStyle(
                              color: Colors.black
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
              ),
              SizedBox(
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
                        style: TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("Referrer Code"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.brown,
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: promocode,
                        style: TextStyle(
                            color: Colors.black87
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          label: Text("Your Promo Code"),
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
                margin: EdgeInsets.only(top: 6),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   ElevatedButton(onPressed: (){}, child: SizedBox(child: Center(child: Text("LOGIN")),width: 90,)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("or"),
                  ),
                  ElevatedButton(onPressed: () async{

                    if(firstname.text==""||lastname.text==""||email.text==""||_countryValue==""||username.text==""||password.text==""){
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
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
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
                      var res = await dbops.register(firstname.text, lastname.text, email.text, phone.text, _countryValue, username.text, password.text,referrercode.text,promocode.text);
                        var resJsoned = json.decode(res);

                        print("RESPONSEY: "+resJsoned["user"][0]["responseCode"].toString());

                        if(resJsoned["user"][0]["responseCode"]==2){
                          print("true");
                          setState(() {
                            responseProcess = resJsoned["user"][0]["responseMessage"];
                          });
                          Navigator.pop(context);

                        }

                        if(resJsoned["user"][0]["responseCode"]==1){
                          Navigator.pop(context);
                          Navigator.pop(context);

                            Get.to(()=>HomeScreen(),transition: Transition.circularReveal);
                        }

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
