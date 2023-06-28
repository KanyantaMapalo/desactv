import 'package:desactvapp3/screens/preview_screen.dart';
import 'package:desactvapp3/screens/watch_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/movie_model.dart';
import '../services/db_ops.dart';

class DocumentariesScreen extends StatefulWidget {
  const DocumentariesScreen({Key? key}) : super(key: key);

  @override
  State<DocumentariesScreen> createState() => _DocumentariesScreenState();
}

class _DocumentariesScreenState extends State<DocumentariesScreen> {

  Map ?data;

  DBOPS dbops = DBOPS();
  List documentaries_talkshow = [];

  @override
  Widget build(BuildContext context) {
    shortMovies()async{
      documentaries_talkshow = await dbops.fetchFetchDocumentariesTalkshow();

    }
    shortMovies();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
              image: AssetImage("assets/backtrailer.jpeg"),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken)
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.black87
          ),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("DOCUME\nNTARY",style: TextStyle(color: Colors.deepOrange,fontSize: 13),),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width-191,
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search_outlined),
                                  iconColor: Colors.teal,
                                  focusColor: Colors.white,
                                  border: InputBorder.none,
                                  enabled: false,
                                  hintText: "Search Documentaries",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5)

                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.menu)
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height-88,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: dbops.fetchFetchDocumentariesTalkshow(),
                              builder: (BuildContext context,AsyncSnapshot snapshot){
                                if(snapshot.data!=null){
                                  return Container(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 20),

                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          height: 300.0,
                                          aspectRatio: 20/4,
                                          autoPlay: true,
                                          scrollPhysics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          autoPlayInterval: Duration(seconds: 5),
                                          enlargeCenterPage: true,
                                          clipBehavior: Clip.none,
                                          autoPlayCurve: Curves.linear,
                                        ),
                                        items: documentaries_talkshow.map((i){
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 290,
                                                    decoration: BoxDecoration(
                                                      image:DecorationImage(
                                                          image: NetworkImage(i.cover),
                                                          fit: BoxFit.cover
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),

                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width-( MediaQuery.of(context).size.width-290),
                                                        padding: EdgeInsets.all(20),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black54,
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(32),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(width:MediaQuery.of(context).size.width-182,child: Text(i.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                                                ElevatedButton(onPressed: (){
                                                                  Get.to(()=>Preview(i));
                                                                }, child: Text("Watch",style: TextStyle(color: Colors.white),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),)
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ],

                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              }),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black54
                              ),
                              child: FutureBuilder(
                                future: dbops.fetchFetchDocumentariesTalkshow(),
                                builder: (BuildContext context,AsyncSnapshot snapshot){
                                  if(snapshot.data!=null){
                                    return     Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(padding:EdgeInsets.only(left:18),child: Text("Talk Show",style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),)),
                                            TextButton(onPressed: (){}, child: Row(children: [Text("view all"),Icon(Icons.arrow_right_alt)],))
                                          ],
                                        ),
                                        Container(
                                          /* margin: EdgeInsets.symmetric(horizontal:20),*/
                                          height: 120,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context,int index){
                                              return GestureDetector(
                                                onTap: ()=>Get.to(()=>Preview(snapshot.data[index])),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                                  width: 100,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.blueAccent,
                                                      image: DecorationImage(
                                                        image:NetworkImage(
                                                          snapshot.data[index].cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 80,
                                                        clipBehavior: Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9)
                                                        ),
                                                        child: FadeInImage(
                                                          placeholder: AssetImage("assets/loader.gif"),
                                                          image: NetworkImage(snapshot.data[index].cover),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 40.0,
                                                        width: MediaQuery.of(context).size.width,
                                                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black87,
                                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(snapshot.data[index].title,style: TextStyle(fontSize: 10),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                            Text("${snapshot.data[index].views} views",style: TextStyle(fontSize: 10,color:Colors.orange),maxLines: 1,overflow: TextOverflow.ellipsis,)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },

                                          ),
                                        )
                                      ],
                                    );
                                  }else{
                                    return Container();
                                  }

                                },
                              )


                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black54
                              ),
                              child: FutureBuilder(
                                future: dbops.fetchFetchDocumentariesSermon(),
                                builder: (BuildContext context,AsyncSnapshot snapshot){
                                  if(snapshot.data!=null){
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(padding:EdgeInsets.only(left:18),child: Text("Sermons",style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),)),
                                            TextButton(onPressed: (){}, child: Row(children: [Text("view all"),Icon(Icons.arrow_right_alt)],))
                                          ],
                                        ),
                                        Container(
                                          height: 120,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context,int index){
                                              return GestureDetector(
                                                onTap: ()=>Get.to(()=>Preview(snapshot.data[index])),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                                  width: 100,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.blueAccent,
                                                      image: DecorationImage(
                                                        image:NetworkImage(
                                                          snapshot.data[index].cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 80,
                                                        clipBehavior: Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(9)
                                                        ),
                                                        child: FadeInImage(
                                                          placeholder: AssetImage("assets/loader.gif"),
                                                          image: NetworkImage(snapshot.data[index].cover),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 40.0,
                                                        width: MediaQuery.of(context).size.width,
                                                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black87,
                                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(snapshot.data[index].title,style: TextStyle(fontSize: 10),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                            Text("${snapshot.data[index].views} views",style: TextStyle(fontSize: 10,color:Colors.orange),maxLines: 1,overflow: TextOverflow.ellipsis,)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },

                                          ),
                                        )
                                      ],
                                    );
                                  }else{
                                    return Container();
                                  }

                                },
                              )


                          ),
                        ],
                      ),
                    ),
                  ),
                ) ,

              ],
            ),
          ),
        ),
      ),
    );
  }
}
