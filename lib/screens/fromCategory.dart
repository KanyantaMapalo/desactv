import 'dart:async';
import 'dart:convert';

import 'package:desactvapp3/services/db_ops.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controller/login.dart';


class FromCategory extends StatefulWidget {
  final category;

  FromCategory(this.category);

  @override
  State<FromCategory> createState() => _FromCategoryState();
}

class _FromCategoryState extends State<FromCategory> {

  bool isLoading = false;
  DBOPS dbops = DBOPS();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category,style: TextStyle(fontSize: 17),),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/awards_back.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          child: FutureBuilder(
            future: dbops.fetchMacNominees(widget.category),
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                if(snapshot.data.length>0){
                  return GridView.builder(
                      clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.only(top: 20),
                    physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        mainAxisExtent: 225

                      ), itemBuilder: (BuildContext context,int index){
                    return  Container(

                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                CircleAvatar(
                                      radius: 67,
                                  backgroundImage: AssetImage("assets/loadingimage.gif",),
                                     foregroundImage: NetworkImage(snapshot.data[index].image,),
                                ),
                                  Positioned(
                                  bottom: 0,
                                    right: 0,
                                    child: isLoading?CircularProgressIndicator(
                                      strokeWidth: 10,
                                      color: Colors.brown ,
                                    ): ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:  MaterialStateProperty.all(Colors.orange)
                                      ),
                                        onPressed: ()async{
                                          setState(() {
                                            isLoading = true;
                                          });

                                          var result =  jsonDecode(await dbops.vote_mac(Get.find<LoginController>().userdets.value.first.userID, snapshot.data[index].id));

                                          if(result["responseCode"]==1){
                                            Get.defaultDialog(
                                              title: isLoading?"Please wait":"${result["message"]}",
                                              titleStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              content: isLoading?Center(
                                                  child: CircularProgressIndicator()
                                              ):Container(
                                              child: Column(
                                              children: [
                                              ListTile(
                                              leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(snapshot.data[index].image),
                                              ),
                                              title: Text(snapshot.data[index].name),
                                              trailing: Icon(Icons.done_outline_rounded,color: Colors.orange,),
                                              ),

                                        ],
                                        ),
                                            ),

                                            );

                                            setState((){
                                              isLoading = false;
                                            });

                                          }else{
                                            setState((){
                                              isLoading = false;
                                            });
                                            Get.defaultDialog(
                                              title: "${result["message"]}",
                                              titleStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              content: Container(
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage: NetworkImage(snapshot.data[index].image),
                                                      ),
                                                      title: Text(snapshot.data[index].name),
                                                      trailing: Icon(Icons.cancel_outlined,color: Colors.red,),
                                                    ),

                                                  ],
                                                ),
                                              ),

                                            );
                                          }
                                          },

                                        child: Icon(Icons.how_to_vote,color: Colors.white,)
                                    )
                                )
                              ],
                            ),

                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(snapshot.data[index].name,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis,maxLines: 2,),
                                      Text('${snapshot.data[index].votes}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                    );
                  });
                }else{
                  return Center(
                    child: Icon(Icons.hourglass_empty_outlined, size: 130,),
                  );
                }
              }else{
                return Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage("assets/loadingimage.gif",),
                  )
                );
              }

            }
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black87,
                Colors.teal,
                Colors.black87,
              ]
            )
          ),
        ),
      ),
    );
  }
}
