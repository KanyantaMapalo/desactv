import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desactvapp3/models/movie_model.dart';
import 'package:desactvapp3/screens/set_questions.dart';
import 'package:desactvapp3/screens/watch_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'cbc_select_content.dart';
import 'fromCategory.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'gameroom.dart';


class Nominees extends StatefulWidget {
  final award;
  Nominees(this.award);

  @override
  State<Nominees> createState() => _NomineesState();
}

  List<String> macCategories = [
    "BEST ACTOR",
    "BEST ACTRESS",
    "BEST COMEDIAN",
    "BEST POET",
    "BEST MUSIC PRODUCER",
    "BEST HIP HOP",
    "BEST R&B",
    "BEST AFRO/ZEDBEAT",
    "BEST GOSPEL",
    "BEST REGGAE/DANCEHALL",
    "BEST UPCOMING",
    "BEST PHOTO/VIDEOGRAPHY",
    "BEST SOCIAL INFLUENCER",
    "HUMANITARIAN AWARD",
    "SPORTS(MALE)",
    "SPORTS(FEMALE)"
  ];

  List<String> letters = ['A','B','C','D','E','F','G','H'];

  TextEditingController _msgController = TextEditingController();

  Widget mac_awards_categories(category){
    return Container(
        child: GestureDetector(
          onTap: (){
             Get.to(()=>FromCategory(category));
          },
          child: Card(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.black12
                  ]
                )
              ),
              child: Text(category,style: TextStyle(color: Colors.grey,fontSize: 19),),
            ),
          ),
        ),
    );
  }

Widget desac_categories(context){
  return Container(
    color: Colors.black87,

    child: Center(
      child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.black12
                    ]
                )
            ),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.black45,
                            height: 90,
                            width: 90,
                            child: Center(
                              child: Icon(Icons.music_note,size: 40,),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-146,
                              child: Center(child: Text("MUSIC",textAlign: TextAlign.center,))),
                        ],
                      ),
                    width: MediaQuery.of(context).size.width-40,
                    height: 90
                  ),
                ),
                SizedBox(height: 15,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.black45,
                            height: 90,
                            width: 90,
                            child: Center(
                              child: Icon(Icons.movie,size: 40,),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width-146,
                              child: Center(child: Text("VIDEO",textAlign: TextAlign.center,))),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width-40,
                      height: 90
                  ),
                ),
              ],
            ),
          ),
    ),
  );
}


class _NomineesState extends State<Nominees> with TickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController (
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text(widget.award,style: TextStyle(fontSize: 16),),
          backgroundColor: Colors.blueGrey.shade900,
          actions: [
            IconButton(
                onPressed: (){
                  Get.bottomSheet(
                      Container(
                        child: Container(

                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 200,
                                child: ListView(
                                  children: [
                                    /*ListTile(
                                                                          onTap: (){
                                                                            Get.to(()=>CBContentSelect());
                                                                          },
                                                                          leading: Icon(Icons.ac_unit_outlined, color: Colors.orange),
                                                                          title: Text("Select Content", style: TextStyle(color: Colors.black)),
                                                                           subtitle: Text("select songs to appear to participants.", style: TextStyle(color: Colors.grey)),
                                                                        ),*/
                                    ListTile(
                                        onTap: (){
                                          Get.to(()=>SetQuestions());
                                        },
                                        leading: Icon(Icons.ac_unit_outlined, color: Colors.orange,),
                                        title: Text("Set question", style: TextStyle(color: Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),),
                                        subtitle: Text("Set question that will be answered by participants.", style: TextStyle(color: Colors.grey))
                                    ),
                                    ListTile(
                                        onTap: (){
                                          Get.to(()=>GameRoom());
                                        },
                                        leading: Icon(Icons.gamepad, color: Colors.orange,),
                                        title: Text("Game Room", style: TextStyle(color: Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),),
                                        subtitle: Text("Gameshow in progress.", style: TextStyle(color: Colors.grey))
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      enableDrag: true,
                      backgroundColor: Colors.white
                  );
                },
                icon: Icon(Icons.admin_panel_settings, size: 40, color: Colors.orange)
            ),
          ],
        ),
        body:Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/awards_back.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: widget.award=="MAC AWARDS"
                ?Container(
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
              height: MediaQuery.of(context).size.height,
              child: SlideTransition(
                position: _animation,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: macCategories.length,
                      itemBuilder: (BuildContext context,int index){
                        return  mac_awards_categories(macCategories[index]);
                      },
                ),
              ),
            )
                :widget.award=="DESAC TV GAMESHOW"
                ?Container(
                  color: Colors.white,
                  child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: Get.width,
                                  color: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffbdb8b7)
                                    ),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('question').where('status',isEqualTo: 'shown').snapshots(),
                                      builder: (context, snapshot) {
                                         if(snapshot.hasData){
                                           if(snapshot.data?.size!=0){
                                             return Container(
                                               decoration: BoxDecoration(
                                                   color: Color(0xfff0f0f0),
                                                 borderRadius: BorderRadius.circular(20)
                                               ),
                                               child: Column(
                                                   children: [
                                                     SizedBox(height: 20,),
                                                     Container(
                                                       padding: EdgeInsets.all(10),
                                                       decoration: BoxDecoration(
                                                         
                                                       ),
                                                       child: Text(snapshot.data?.docs[0].get("question")[0]["question"],style: TextStyle(fontSize: 20,color:Colors.teal,fontWeight: FontWeight.bold),),
                                                     ),
                                                     Expanded(
                                                         child: Container(
                                                           child: ListView.builder(
                                                             itemCount: snapshot.data?.docs[0].get("question")[0]["answers"].length,
                                                             itemBuilder: (context,index){
                                                               return ListTile(
                                                                 leading: CircleAvatar(child: Text('${letters[index]}',style: TextStyle(fontSize: 18,color: Colors.redAccent))),
                                                                 title: Text(snapshot.data!.docs[0].get("question")[0]["answers"][index]["answer"].toString().capitalizeFirst??snapshot.data!.docs[0].get("question")[0]["answers"][index].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent)),
                                                                 trailing: ElevatedButton(
                                                                   style: ButtonStyle(
                                                                     backgroundColor: MaterialStatePropertyAll(Colors.green)
                                                                   ),
                                                                   onPressed: (){
                                                                     Get.defaultDialog(
                                                                       content: Container(
                                                                         child: Column(
                                                                           children: [
                                                                             Text(snapshot.data?.docs[0].get("question")[0]["question"],style: TextStyle(fontSize: 18,color:Colors.teal,fontWeight: FontWeight.bold)),
                                                                             SizedBox(height: 20),
                                                                             Container(child: Text(snapshot.data!.docs[0].get("question")[0]["answers"][index]["answer"].toString(),style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),)),
                                                                             SizedBox(height: 20),
                                                                             ElevatedButton(
                                                                                 style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                                                                                 onPressed: (){

                                                                                  FirebaseFirestore.instance.collection('answered').add({
                                                                                    "question":snapshot.data?.docs[0].get("question")[0]["question"],
                                                                                    "answer":snapshot.data!.docs[0].get("question")[0]["answers"][index],
                                                                                    "user":GetStorage().read('userId'),
                                                                                    "accuracy":snapshot.data!.docs[0].get("question")[0]["answers"][index]["correct"],
                                                                                  }).then((value){
                                                                                    FirebaseFirestore.instance.collection('question').doc(snapshot.data!.docs[0].id).update({
                                                                                      "status":"attempted"
                                                                                    });

                                                                                    Navigator.pop(context);

                                                                                  });

                                                                                 }, child: Text("Confirm",style: TextStyle(color: Colors.white,),),                                  )
                                                                           ],
                                                                         ),
                                                                       )
                                                                     );
                                                                   },
                                                                   child: Text("Answer",style: TextStyle(color: Colors.white),)
                                                                 )
                                                               );
                                                             },
                                                           ),
                                                         ),
                                                     )
                                                   ]
                                               ),
                                             );
                                           }else{
                                             return Container(
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Icon(Icons.ac_unit, color: Colors.teal,size: 60),
                                                   SizedBox(height: 20),
                                                   Text("QUESTION WILL APPEAR HERE",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold))
                                                 ],
                                               )
                                             );
                                           }
                                         }else{
                                           return Container(
                                             child: Center(
                                               child: CircularProgressIndicator()
                                             ),
                                           );
                                         }
                                      }
                                    )
                                  )
                                  /*StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("cbc_weekly_content").snapshots(),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        if(snapshot.data?.size!=0){
                                          return GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: snapshot.data?.docs[0].get("content").length,
                                            itemBuilder: (context,int index){
                                              return GestureDetector(
                                                onTap: (){
                                                  var item = MovieModel(snapshot.data?.docs[0].get("content")[index]["title"], snapshot.data?.docs[0].get("content")[index]["description"], snapshot.data?.docs[0].get("content")[index]["cover"], snapshot.data?.docs[0].get("content")[index]["url"], snapshot.data?.docs[0].get("content")[index]["id"], "", "", snapshot.data?.docs[0].get("content")[index]["views"], "music");
                                                  Get.to(()=>Video(item));
                                                },
                                                child: Card(
                                                  elevation: 20,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white70,
                                                          borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Center(
                                                              child: CircleAvatar(
                                                                radius: 40,
                                                                backgroundImage: NetworkImage(snapshot.data?.docs[0].get("content")[index]["cover"]),
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("${snapshot.data?.docs[0].get("content")[index]["title"]}",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: Colors.blueGrey,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                            ),textAlign: TextAlign.center,

                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  color: Colors.black,
                                                ),
                                              );
                                            }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),);
                                        }else{
                                          return Center(
                                            child: Text("Empty!")
                                          );
                                        }
                                      }else{
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                    }
                                  )*/
                                ),
                              ),
                              Container(
                                width: Get.width,
                                color: Colors.grey,
                                padding: EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: (){
                                    Get.bottomSheet(
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance.collection('answered').where("user",isEqualTo: GetStorage().read('userId')).snapshots(),
                                          builder: (context,snapshot){
                                            if(snapshot.hasData){
                                              if(snapshot.data?.size!=0){
                                                return ListView.builder(
                                                  itemCount: snapshot.data?.size,
                                                  itemBuilder: (context,index){
                                                    return ListTile(
                                                      title: Text(snapshot.data?.docs[index].get("question"),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                                                      subtitle: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text("Your Answer: ",style: TextStyle(color: Colors.teal),),
                                                              Text(snapshot.data?.docs[index].get("answer")["answer"],style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text("Accuracy: ",style: TextStyle(color: Colors.teal),),
                                                              Text(snapshot.data?.docs[index].get("accuracy")?"True":"False",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }else{
                                                return Container();
                                              }
                                            }else{
                                              return Container();
                                            }
                                          },
                                        ) ),
                                      backgroundColor: Colors.white,
                                      
                                    );
                                  },
                                  child: Text("View questions you attempted!"),
                                ),
                              )
                            ]
                          ),
                        ),

            )
                :desac_categories(context),
          ),
    );
  }
}
