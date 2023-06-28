import 'dart:convert';
import 'package:get/get.dart';
import 'package:desactvapp3/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'downloads_watch.dart';
import 'dart:io';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  GetStorage storage = GetStorage();
  @override
  Widget build(BuildContext context) {
//   var jsoned = json.decode(storage.read("downloads"));

   
   Future<List<MovieModel>>getDownloads()async{
      List<MovieModel> list = [];
      
      for(var movie in storage.read("downloads")){
        MovieModel move = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["cover"], movie["url"].toString(), movie["id"], movie["duration"], "","",movie['type']);
        
        list.add(move);
     
      }
      
     return list;
   }

    return Scaffold(
      appBar: AppBar(title: Text("Downloads (${storage.read("downloads")!=null?storage.read("downloads").length:0})")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
        child: Center(
          child: FutureBuilder(
            future: getDownloads(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data != null){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                    itemBuilder: (context,int index){
                  return Column(
                    children: [
                      ListTile(
                        onTap: ()=>{
                          Get.to(()=>DVideo(snapshot.data[index]),transition: Transition.zoom)
                        },
                        leading: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          width: 80,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset('assets/videofile.png',fit: BoxFit.cover,),
                        ),
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].description,style: TextStyle(),maxLines: 1, overflow: TextOverflow.ellipsis,),
                        trailing: IconButton(icon:Icon(Icons.more_vert),onPressed: (){
                          _showBottomSheetLocation(snapshot.data[index]);
                        },),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 0.5,
                      )
                    ],
                  );
                });
              }else{
                return Center(
                  child: Image.asset("assets/no-media.png"),
                );
              }
            },
            
          ),
        ),
      ),
    );

  }

  Future _showBottomSheetLocation(movie) async{
    showModalBottomSheet<void>(
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
              heightFactor: 0.55,
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
                            color: Colors.grey[300]
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                      child:Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height-329,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage('assets/album.png'),
                                              fit: BoxFit.cover
                                          ),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:9.0,top: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Title:",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                          Text(movie.title,style: TextStyle(color: Colors.black),),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(onPressed: (){
                                        deleteFile(movie.url);
                                      }, child: Row(
                                        children: [
                                          Icon(Icons.delete_forever_rounded,color:Colors.red),
                                          Text("Delete")
                                        ],

                                      )),
                                        SizedBox(width: 15,),
                                      ElevatedButton(onPressed: (){
                                        Get.to(()=>DVideo(movie),transition: Transition.zoom);
                                      }, child: Row(
                                        children: [
                                          Icon(Icons.video_collection,color:Colors.green),
                                          Text(" Watch")
                                        ],

                                      )),

                                    ],
                                  ),
                                
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
  Future<int> deleteFile(path) async {
    try {
      final file = File(path);
      var old = storage.read("downloads");
      await file.delete();
      Navigator.pop(context);
      setState(() {
        List result = old.removeWhere( (item) => item["url"] == path );
        storage.write("downloads", old);
      });
      Get.snackbar("_", "Deleted Successfully!");
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
