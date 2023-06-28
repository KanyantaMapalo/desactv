import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetQuestions extends StatefulWidget {
  @override
  _SetQuestionsState createState() => _SetQuestionsState();
}

class _SetQuestionsState extends State<SetQuestions> {
  List<Map>questions = [];
  List<Map> answers = [];
  List<String> letters = ["a","b","c","d","e","f","g"];
  TextEditingController multipleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  bool istrue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Text('Set Question'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TextField(
                    controller: questionController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Question',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: multipleController,
                          decoration: InputDecoration(
                            labelText: 'Add Answer',
                            labelStyle:TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {

                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      SizedBox(width: 30,child: CheckboxListTile(value: istrue, onChanged: (value){
                        setState(() {
                          istrue = value!;
                        });
                      })),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                        onPressed: () {
                          setState(() {
                            answers.add({"answer":multipleController.text,"correct":istrue});
                            istrue = false;
                            multipleController.text = "";
                          });
                        },
                        child: Icon(Icons.add,color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Multiple Choice Answers:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color:Colors.black),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(letters[index][0].capitalizeFirst??"",style: TextStyle(color: Colors.teal,fontSize: 16),),
                          title: Text(answers[index]["answer"],style: TextStyle(color: Colors.black),),
                          trailing: IconButton(onPressed: (){
                            setState(() {
                              answers.removeAt(index);
                            });
                          }, icon: Icon(Icons.remove,color: Colors.red,)),
                        );
                      },
                    ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){
                            FirebaseFirestore.instance.collection("question").add(
                                {
                                  "status":"hidden",
                                  "question":[{
                                    "question":questionController.text,
                                    "answers":answers
                                  }],
                                }
                            ).then((value){
                              setState(() {
                                answers.clear();
                                multipleController.text = '';
                                questionController.text = "";

                                print(questions);
                              });
                            });
                          }, child: Text("Add Question")),

                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: StreamBuilder(stream: FirebaseFirestore.instance.collection("question").snapshots(), builder: (context,snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data?.size!=0){
                          return ListView.builder(itemCount:snapshot.data?.size,itemBuilder: (c,i){
                            return ListTile(
                              onTap: (){
                                Get.bottomSheet(
                                  StatefulBuilder(
                                    builder: (context,state) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: StreamBuilder(
                                                stream: FirebaseFirestore.instance.collection('question').doc(snapshot.data!.docs[i].id).snapshots(),
                                                builder: (context, snapshot1) {
                                                  if(snapshot1.hasData){
                                                    if(snapshot1.data?.data()?.length!=0){
                                                      return ListTile(
                                                        title: Text(snapshot1.data!.get("question")[0]["question"].toString(),style: TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.bold),),
                                                        subtitle: Row(
                                                          children: [
                                                            Icon(Icons.remove_red_eye),
                                                            SizedBox(width: 15),
                                                            Text(snapshot1.data!.get("status").toString(),style: TextStyle(fontSize: 14,color: snapshot1.data!.get("status")=="hidden"?Colors.deepOrange:Colors.blue,fontWeight: FontWeight.bold),),
                                                          ],
                                                        ),
                                                        trailing: ElevatedButton(
                                                            onPressed: (){
                                                              snapshot1.data!.get("status")=="hidden"?
                                                              FirebaseFirestore.instance.collection('question').doc(snapshot.data!.docs[i].id).update({"status":"shown"}).then((value){
                                                                Get.updateLocale(Locale("EN"));
                                                              }): FirebaseFirestore.instance.collection('question').doc(snapshot.data!.docs[i].id).update({"status":"hidden"}).then((value){
                                                                Get.updateLocale(Locale("EN"));
                                                              });
                                                            }, child: Text(snapshot1.data!.get("status")=="hidden"?"Show":"Hide")),
                                                      );
                                                    }else{
                                                      return Container();
                                                    }
                                                  }else{
                                                    return Container();
                                                  }
                                                }
                                              ),
                                            ),
                                            Divider(),
                                            Expanded(child: ListView.builder(
                                              itemCount: snapshot.data!.docs[i].get("question")[0]["answers"].length,
                                                itemBuilder: (context,index){
                                              return ListTile(
                                                leading: CircleAvatar(child: Text(letters[index].capitalizeFirst??"",style: TextStyle(fontSize: 18,color: Colors.teal),)),
                                                title: Text(snapshot.data!.docs[i].get("question")[0]["answers"][index]["answer"],style: TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.bold),),
                                                subtitle: Text(snapshot.data!.docs[i].get("question")[0]["answers"][index]["correct"]?"Correct":"Incorrect",style: TextStyle(fontSize: 16,color: !snapshot.data!.docs[i].get("question")[0]["answers"][index]["correct"]?Colors.red:Colors.blue),),
                                              );
                                            }))
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                  backgroundColor: Colors.white
                                );
                              },
                              leading: CircleAvatar(
                                child: Text((i+1).toString(), style: TextStyle(fontSize: 20,color: Colors.teal,fontWeight: FontWeight.bold),)
                              ),
                              title: Text(snapshot.data!.docs[i].get("question")[0]["question"].toString(),style: TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.bold),),
                              subtitle: Row(
                                children: [
                                  Text("Status: ",style: TextStyle(fontSize: 14,color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                                  Text(snapshot.data!.docs[i].get("status"),style: TextStyle(fontSize: 14,color: Colors.red,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: (){
                                  FirebaseFirestore.instance.collection('question').doc(snapshot.data?.docs[i].id).delete();
                                },
                                icon: Icon(Icons.delete_forever_rounded, color: Colors.red)
                              )
                            );
                          });
                        }else{
                          return Container();
                        }
                      }else{
                        return Container();
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
