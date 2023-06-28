import 'dart:async';
import 'dart:convert';

import 'package:desactvapp3/screens/paymentConfirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:desactvapp3/services/tingg_payments.dart';
import '../controller/login.dart';
import '../models/subscription_model.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';

class CheckoutScreen extends StatefulWidget {
  SubModel sub;
  CheckoutScreen(this.sub);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {


  Tingg tingg = Tingg();

  GetStorage storage = GetStorage();
  var seasonedUser;
  String _paymentOpt = "";
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Widget paymentResponseWidget = Text("");
  bool processing = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  image: DecorationImage(
                      image: AssetImage("assets/backtrailer.jpeg"),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken)
                  )
              ),
              child: SingleChildScrollView(
                  child:Container(
                      height: MediaQuery.of(context).size.height,
                  color: Colors.white70,
                  child: Column(
                      children: [
                        Card(
                          elevation: 20,
                          child: Container(
                            height: 130,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Plan: "),
                                    Text(widget.sub.plan),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Price: "),
                                    Text('K${widget.sub.price}'),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Text("Details: "+widget.sub.info)
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.orange)
                                      ),
                                      onPressed: (){
                                        Get.back();
                                      }, child: Text("Change",style: TextStyle(color: Colors.black),),
                                    )
                                  ],
                                )
                              ],
                            ),

                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                              color: Colors.black12,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text("Payment Type:",style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            title: const Text('Mobile Money',style: TextStyle(color: Colors.black),),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.all(Colors.orange),
                                              splashRadius: 10,
                                              value: "Mobile Money",
                                              groupValue: _paymentOpt,
                                              onChanged: (value) {
                                                setState(() {
                                                  _paymentOpt = value!;
                                                  print(_paymentOpt);
                                                }) ;
                                              },
                                            )
                                        ),
                                        _paymentOpt=="Mobile Money"?Container(
                                          height: 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  tingg.authentication();
                                                  _showBottomSheetLocation("MTN MoMO","assets/mtn.png","293");
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                                  height: 60,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(20),
                                                      image: DecorationImage(
                                                          image: AssetImage("assets/mtn.png"),
                                                          fit: BoxFit.cover
                                                      )
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  _showBottomSheetLocation("Airtel Money","assets/airtel.png","334");
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage("assets/airtel.png"),
                                                          fit: BoxFit.cover
                                                      ),
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  _showBottomSheetLocation("Zamtel Money","assets/zamtel.png","335");
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                                  height: 60,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage("assets/zamtel.png"),
                                                          fit: BoxFit.cover
                                                      ),
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ):Container(),
                                        ListTile(
                                            title: const Text('VISA Card ',style: TextStyle(color: Colors.black)),
                                            leading: Radio(
                                              fillColor: MaterialStateProperty.all(Colors.orange),
                                              value: "Cards",
                                              groupValue: _paymentOpt,
                                              onChanged: (value) {
                                                setState(() {
                                                  _paymentOpt = value!;
                                                  print(_paymentOpt);
                                                }) ;
                                              },
                                            )
                                        ),
                                        _paymentOpt=="Cards"?Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                          ),
                                          height: 260,
                                          child: SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Column(
                                                children: [
                                                  const Spacer(),
                                                  Form(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(

                                                          controller: cardNumberController,
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            LengthLimitingTextInputFormatter(19),
                                                          ],
                                                          decoration: InputDecoration(
                                                            hintText: "Card number",
                                                            suffixIcon: Icon(Icons.credit_card)
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                                          child: TextFormField(
                                                            decoration:
                                                            const InputDecoration(hintText: "Full name"),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  // Limit the input
                                                                  LengthLimitingTextInputFormatter(4),
                                                                ],
                                                                decoration: const InputDecoration(hintText: "CVV"),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 16),
                                                            Expanded(
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(5),
                                                                ],
                                                                decoration:
                                                                const InputDecoration(hintText: "MM/YY"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(flex: 2),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: ElevatedButton(
                                                      child: const Text("Add card"),
                                                      onPressed: () {},
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ):Container(),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: paymentResponseWidget,
                        )
                      ]
                  )
              )
          ),
        ),
      ),
    );
  }
  Future _showBottomSheetLocation(payerName,payerLogo,payerModeId) async{
    showModalBottomSheet<void>(
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 20,
      isScrollControlled:true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,setState){
          return FractionallySizedBox(
              heightFactor: 0.60,
              widthFactor: 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: 6.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.blueGrey
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(child:Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 227,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("${payerLogo}"),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:9.0,top: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("K${widget.sub.price}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                                      Text("Paying with ${payerName}",style: TextStyle(color: Colors.white),),

                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:0),
                              child: Container(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(19),
                                        ],
                                        decoration: InputDecoration(
                                            label: Text("Phone Number"),
                                            suffixIcon: Icon(Icons.phone_android)
                                        ),
                                      ),
                                      SizedBox(height: 14,),
                                      ElevatedButton(
                                        onPressed: () async{
                                          processPayment(payerModeId);
                                          setState(()=>processing=true);
                                        },
                                        child: !processing?Text("Pay Now"):CircularProgressIndicator()
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),

                    ],
                  ))
                ],
              )
          );
        });
      },
    );
  }

  processPayment(payerModeID) async{
    String duration = "1";

    switch(widget.sub.plan){
      case "Daily":
        duration = "1";
        break;
      case "Weekly":
        duration = "7";
        break;
      case "Monthly":
        duration = "30";
    }


    if(phoneController.text!=""){
      String response = await tingg.initCharge(widget.sub.price, Get.find<LoginController>().userdets.value.first.firstname, Get.find<LoginController>().userdets.value.first.lastname, Get.find<LoginController>().userdets.value.first.email,phoneController.text,Get.find<LoginController>().userdets.value.first.userID,duration);
      var jsoned = json.decode(response);

     // print("CONVERVTED TINNGER: "+jsoned["results"]["paymentInstructions"].toString());

      //payerModeID
      //293 mtn
      //334 airtel
      //335 zamtel

      String chargeResponse = await tingg.postCharge(jsoned["results"]["merchantTransactionID"],jsoned["results"]["checkoutRequestID"], phoneController.text,jsoned["results"]["requestAmount"],jsoned["results"]["originalCurrencyCode"],payerModeID);

      var chargeJsoned = json.decode(chargeResponse);
      setState(() {
        processing = false;
      });
      Navigator.pop(context);
      Get.to(()=>PaymentConfirm(chargeResponse),transition: Transition.leftToRightWithFade);

    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(''); // Add double spaces.
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }


}