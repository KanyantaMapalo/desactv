import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/airtel_money.dart';
import '../services/db_ops.dart';
import 'checkout.dart';

class SubscriptionScreen extends StatefulWidget {

    SubscriptionScreen();

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  DBOPS dbops = DBOPS();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Subscription Plans"),
        ),
        body: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                image: DecorationImage(
                  image: AssetImage("assets/backtrailer.jpeg"),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken)
                )
              ),

          child: Container(
                color: Colors.black87,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  child: Center(
                    child:  FutureBuilder(
                  future: dbops.getSubscriptions(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data!=null){

                      return Container(

                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                              child:  SizedBox(
                                child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white10,
                                        boxShadow: [BoxShadow(color: Colors.black87,spreadRadius: 1,blurRadius:15)]
                                      ),
                                      padding: EdgeInsets.all(21),

                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(snapshot.data[index].plan,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20),),
                                            Container(
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: Colors.cyan.shade900,
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                              ),
                                            )
                                            ],
                                          )
                                         , Column(
                                           children: [
                                             Row(
                                                children: [
                                                  Icon(Icons.arrow_right_outlined, color: Colors.green,size: 35,),
                                                  Text(snapshot.data[index].info)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  snapshot.data[index].ads=="1"?Icon(Icons.check,color: Colors.green,size: 35,):Icon(Icons.close,color: Colors.red,size: 35,),
                                                  Text("Ads")
                                                ],
                                              ),
                                             Row(
                                               children: [
                                                 Icon(Icons.money,color: Colors.orange,size: 25,),
                                                 Padding(
                                                   padding: const EdgeInsets.all(8.0),
                                                   child: Text("K${snapshot.data[index].price}",style: TextStyle(fontSize: 20),),
                                                 )
                                               ],
                                             ),
                                           ],
                                         ),
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent)
                                              ),
                                              onPressed: (){
                                                print(snapshot.data[index].id);
                                                Get.to(()=>CheckoutScreen(snapshot.data[index]),transition: Transition.circularReveal);
                                              },
                                              child: Container(
                                                width: 70,
                                                  child: Center(child: Text("GET",style: TextStyle(
                                                    color: Colors.black87
                                                  ),))
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              ),
                            );
                          },

                        ),
                      );
                    }else{
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width:100,height: 3,child: LinearProgressIndicator(color: Colors.cyan.shade900)),
                            Text("Fetching Plans...",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      );
                    }

                })
        ))
              )));



  }
}
