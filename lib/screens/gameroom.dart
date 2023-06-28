import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_loading/widget_loading.dart';

class GameRoom extends StatefulWidget {
  const GameRoom({Key? key}) : super(key: key);

  @override
  State<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe4e8e9),
      appBar: AppBar(
        backgroundColor: Color(0xff147c94),
        title: Text("Game Room!")
      ),
      body: Container(
        width: Get.width,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 25
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff9f1515),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomLeft: Radius.circular(40))
                  ),
                  padding: EdgeInsets.all(20),
                  child: StreamBuilder(
                    stream: firestore.collection('question').where('status',isEqualTo: 'shown').snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data?.size!=0){
                          return Text(snapshot.data?.docs[0].get("question")[0]["question"], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
                        }else{
                          return Text("NONE", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
                        }
                      }else{
                        return Text("---", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
                      }
                    }
                  ),
                ),
                Positioned(
                     top: -10,
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xff9f1515),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text("Current Question"),))
              ],
            ),
            SizedBox(
              height: 20
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('question').where('status',isNotEqualTo: 'shown').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data?.size!=0){
                       return  ListView.builder(
                         itemCount: snapshot.data?.size,
                           itemBuilder: (context,index){
                         return Dismissible(
                           key: Key(""),
                           onDismissed: (direction){

                           },
                           confirmDismiss: (c)async{
                               firestore.collection('question').where('status',isEqualTo: 'shown').get().then((value){
                                 for(int i = 0; i < value.size; i++){
                                   String id = value.docs[i].id;
                                   firestore.collection('question').doc(id).update({
                                     "status":"hidden"
                                   }).then((value){
                                     firestore.collection('question').doc(snapshot.data?.docs[index].id).update({"status":"shown"});
                                   });
                                 }
                               });
                               return false;
                             },
                           direction: DismissDirection.up,
                           background: Center(
                             child: Text("Switch Question",style: TextStyle(color: Colors.redAccent),),
                           ),
                           child: ListTile(
                             leading: CircleAvatar(
                               child: Text('${index+1}'),
                             ),
                             title: Text(snapshot.data!.docs[index].get("question")[0]["question"].toString(),style: TextStyle(color: Colors.brown,fontSize:18,fontWeight: FontWeight.bold)),
                             subtitle: Text(snapshot.data!.docs[index].get("status").toString().capitalizeFirst??"",style: TextStyle(color: Colors.green),),
                             trailing: IconButton(
                                 onPressed:(){

                                  },
                                 icon:Icon(Icons.swipe_up,size:40,color: Color(0xff074854),)),
                           ),
                         );
                       });
                      }else{
                        return Container();
                      }
                    }else{
                      return Container();
                    }
                  }),
            ),
            ElevatedButton(onPressed: (){
              Get.bottomSheet(
                  Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Participations",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            height: 200,
                            child: StreamBuilder(stream: firestore.collection('answered').snapshots(), builder: (context,snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data?.size!=0){
                                  return ListView.builder(
                                      itemCount: snapshot.data?.size,
                                      itemBuilder: (context,index){
                                        return ListTile(
                                          title: Text(snapshot.data?.docs[index].get("answer")["answer"],style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.brown)),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data?.docs[index].get("question"),style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.green)),
                                              Text(snapshot.data?.docs[index].get("accuracy")?"Correct":"Incorrect",style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.green)),
                                              Row(
                                                children: [
                                                  Text("Participant: ",style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.green)),

                                                  Text(snapshot.data?.docs[index].get("user"),style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.green)),
                                                ],
                                              ),

                                            ],
                                          ),
                                        );
                                      });
                                }else{
                                  return Center(
                                    child: Text(""),
                                  );
                                }
                              }else{
                                return Center(
                                  child: CircularWidgetLoading(child: Text(""),),
                                );
                              }
                            }),
                          )
                        ],
                      )
                  ),
                backgroundColor: Colors.white
              );
            }, child: Text("Participants"))
          ],
        ),
      ),
    );
  }
}
