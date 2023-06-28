import 'package:desactvapp3/screens/subscription_plans_screen.dart';
import 'package:desactvapp3/screens/watch_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_subscription_controller.dart';
import '../models/movie_model.dart';



class Preview extends StatelessWidget {
  MovieModel movie;
   Preview(this.movie);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(movie.cover),
              fit: BoxFit.cover
            )
          ),
          child: SingleChildScrollView(
            child: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage("assets/banner.jpeg")
                          )
                        ),
                      ),
                      Positioned(
                        top: 40,
                          left: 20,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: MediaQuery.of(context).size.width-40,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              boxShadow: [BoxShadow(color: Colors.black45,spreadRadius: 6,blurRadius: 10)],
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Image.network(movie.cover, fit: BoxFit.cover),
                          )
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(top: 40),
                    height: 156,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                SizedBox(width:10),
                                Text(movie.views)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.download),
                                Text("10%")
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.directions_run_rounded),
                                Text("16%")
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(movie.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        Text(movie.description,textAlign:TextAlign.center,style:TextStyle(color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  ),
                  Container(height: 1,decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(2)
                  ),margin: EdgeInsets.symmetric(vertical: 30),),
                  Get.find<UserSubController>().usersubdetails.value.first.status=="active"?ElevatedButton(onPressed: (){
                    Get.to(()=>Video(movie));
                  }, child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text("WATCH",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),):Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text("Your subscription is inactive. Kindly subscribe to watch.",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.green)
                          ),
                            onPressed: (){
                          Get.to(SubscriptionScreen());
                        }, child: Text("Subscribe",style: TextStyle(color: Colors.white),))
                      ],
                    ),
                  )
            ])),
          )
        ),
      ),
    );
  }
}
