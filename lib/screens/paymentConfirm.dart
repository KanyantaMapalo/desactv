import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/tingg_payments.dart';

class PaymentConfirm extends StatefulWidget {
  String user;
  PaymentConfirm(this.user);


  @override
  State<PaymentConfirm> createState() => _PaymentConfirmState();
}

class _PaymentConfirmState extends State<PaymentConfirm> {
  late Timer timer;
  bool confirmed = false;
  Tingg tingg = Tingg();
  GetStorage storage = GetStorage();
  int _counter = 0;
  bool confirming = false;

  @override
  Widget build(BuildContext context) {
    var jsonedUser = json.decode(widget.user);
    print(jsonedUser);

    return Scaffold(
      body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("RequestID:", style: TextStyle(
                          color: Colors.red,
                        ),),
                        Text("${jsonedUser["results"]["checkoutRequestID"]}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Date:", style: TextStyle(
                          color: Colors.red,
                        ),),
                        Text("${jsonedUser["results"]["chargeRequestDate"]}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: !confirmed
                      ? Text(
                      'You will receive a prompt on the mobile number ${jsonedUser["results"]["chargeMsisdn"]}. '
                          'Enter your PIN to authorize your payment of ZMW ${jsonedUser["results"]["chargeAmount"]}.')
                      : Text("Thanks! Your Subscription is now active."),
                ),
              ),
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        !confirmed ? CircularProgressIndicator(
                          color: Colors.green, strokeWidth: 7.0,) : Icon(
                          Icons.check, size: 50, color: Colors.green,),
                        SizedBox(height: 15,),
                        Text(!confirmed ? "Requesting" : "Confirmed")
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(20),
                child: !confirmed ? ElevatedButton(
                  onPressed: () {

                    timer = Timer.periodic(Duration(seconds:1), (timer) {
                      confirm();
                      setState(() {
                        _counter++;
                        confirming=true;
                      });
                    });
                  },
                  child: Text("Complete Payment"),
                ) : ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Go to Home"),
                ),
              ),
              confirming?Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !confirmed?Text("Confirming "):Text("Confirmed in"),
                    Text(_counter.toString(),style: TextStyle(color: Colors.red,fontSize: 40),),
                    Text(" Seconds "),
                  ],
                ),
              ):Text("")
            ],
          )
      ),
    );
  }

  confirm() async {
    String response = await tingg.queryStatus(storage.read("userid"));
    print(response);

    if (response == "1") {
      print("TRUE");
      setState(() {
        confirmed = true;
        timer.cancel();
      });
    }
  }

}
