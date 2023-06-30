
import 'package:desactvapp3/screens/polling_screen.dart';
import 'package:desactvapp3/screens/profile.dart';
import 'package:desactvapp3/screens/search.dart';
import 'package:desactvapp3/screens/settings_screen.dart';
import 'package:desactvapp3/screens/subscription_plans_screen.dart';
import 'package:desactvapp3/screens/watch_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../services/db_ops.dart';
import 'about_us_screen.dart';
import 'downloads_screen.dart';
import 'login_screen.dart';
import 'messages.dart';
import 'movies_screen.dart';
import 'documentaries_screen.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../services/fetch_trailers_service.dart';
import 'music_screen.dart';
import 'package:desactvapp3/screens/profile.dart';

import 'notifications.dart';


class HomeScreen extends StatefulWidget {

   HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DBOPS dbops = DBOPS();

  int counterClose = 0;

  int _selectedIndex = 0;
  final List<Widget> _pages = [Container(),    Container(),    Container(),    Container(),];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
      switch(_selectedIndex){
        case 3: Get.to(()=>ProfileScreen());
        break;
        case 1: Get.to(()=>Search());
        break;
        case 2: Get.to(()=>Notifications());
        break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // Get.find<UserSubController>().getUserSub(Get.find<LoginController>().userdets.value.first.userID);
    return WillPopScope(
      onWillPop: () async{
        Get.snackbar("_", "Tap again to close application");

        if(counterClose==0){
          setState(() {
            counterClose++;
          });
          return false;
        }else{
          return true;
        }



      },
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          elevation: 15,
          onPressed: ()=>Get.to(()=>PollingScreen(),transition: Transition.zoom),
          child: Icon(Icons.how_to_vote_outlined),
          splashColor: Colors.orange,
        ),
        drawerEdgeDragWidth: 60,
        drawer: Drawer(
          elevation: 10,
          backgroundColor: Colors.black87,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/backtrailer.jpeg"
                ),
                fit: BoxFit.cover
              )
            ),
            child:  SingleChildScrollView(
              child: Column(
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage("assets/de.png"),
                            opacity: .08,
                            alignment: Alignment.bottomRight,
                            scale: 3,filterQuality: FilterQuality.medium
                          ),
                        ),
                        child:Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap:()=>Get.to(()=>ProfileScreen(),transition: Transition.leftToRightWithFade),
                                child: ListTile(
                                  textColor: Colors.white,
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage("assets/de.png"),
                                    radius: 35,
                                  ),
                                  title: GestureDetector(
                                      onTap: (){
                                        Get.to(()=>ProfileScreen(),transition: Transition.leftToRightWithFade);
                                      },
                                      child: Text("${GetStorage().read('firstname')} ${GetStorage().read('lastname')}", style: TextStyle(color: Colors.blue, fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  subtitle: Text("${GetStorage().read('email')}",maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11.5
                                  ),),

                                ),
                              ),
                              ],
                          ),

                        )
                        )),
                    
                       Container(
                        color: Colors.black87,
                        height: MediaQuery.of(context).size.height-161,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                                height: (MediaQuery.of(context).size.height-130) - (113),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.movie,color: Colors.white,),
                                        title: Text("Movies",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                        onTap: ()=>Get.to(()=>MoviesScreen()),
                                      ),
                                      Container(height: .2,color: Colors.green,),
                                      ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.queue_music,color: Colors.white,),
                                        title: Text("Music",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                        onTap: ()=>Get.to(()=>MusicScreen(),transition: Transition.rightToLeftWithFade),
                                      ),
                                      Container(height: .2,color: Colors.green,),
                                      ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.satellite_rounded,color: Colors.white,),
                                        title: Text("Documentaries",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                        onTap: ()=>Get.to(()=>DocumentariesScreen(),transition: Transition.leftToRightWithFade),
                                      ),
                                      Container(height: .2,color: Colors.green,),
                                      ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.download_done_sharp,color: Colors.white,),
                                        title: Text("Downloads",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                          onTap: ()=>Get.to(()=>DownloadsScreen(),transition: Transition.leftToRightWithFade)
                                      ),
                                      Container(height: .2,color: Colors.green,),
                         /*             ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.settings,color: Colors.white,),
                                        title: Text("Settings",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                          onTap: ()=>Get.to(()=>SettingsScreen(),transition: Transition.leftToRightWithFade)
                                      ),
                                      Container(height: .2,color: Colors.green,),*/
                                      ListTile(
                                        tileColor: Colors.black,
                                        leading: Icon(Icons.info,color: Colors.white,),
                                        title: Text("About Us",style: TextStyle(color: Colors.white),),
                                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                          onTap: ()=>Get.to(()=>AboutUsScreen(),transition: Transition.leftToRightWithFade)
                                      ),
                                      Container(height: .2,color: Colors.green,),
                                      ListTile(
                                          tileColor: Colors.black,
                                          leading: Icon(Icons.subscriptions,color: Colors.white,),
                                          title: Text("Subscription Plans",style: TextStyle(color: Colors.white),),
                                          trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                          onTap: (){
                                            Get.to(()=>SubscriptionScreen());
                                          }
                                      ),
                                      Container(height: .2,color: Colors.green,),
                                    ],
                                  ),
                                ),
                            ),
                            Container(
                              height: 70,
                              width: 100,
                              margin: EdgeInsets.only(top: 0),
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 ElevatedButton.icon(
                                    onPressed: (){
                                      Get.to(()=>LoginScreen(),transition: Transition.cupertinoDialog);
                                    }, icon: Icon(
                                      Icons.logout
                                  ), label: Text("Sign out"),
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all(Colors.black),
                                      backgroundColor: MaterialStateProperty.all(Colors.cyan),

                                    ),
                                  ),
                                  Text("${GetStorage().read('country')}")
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    
                  ],
                ),
            ),
            ),

        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backtrailer.jpeg"),
              fit: BoxFit.cover
            ),
            color: Colors.black,
          ),
          child: Container(
            color: Colors.black87,
            child: Stack(
              children: [

                Column(
                children: [
                      Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            padding: EdgeInsets.only(top: 20),
                            child:ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                      "assets/de.png"
                                    ),
                                  ),
                                  title: Text("DESAC TV", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                                )
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                Get.to(()=>Messages());
                              }, icon: Icon(Icons.message,color:Colors.grey)),
                              IconButton(
                                  onPressed: () => scaffoldKey.currentState?.openDrawer(),
                                  icon: Icon(Icons.menu,color: Colors.grey,),
                                  
                                ),
                            ],
                          )
                        ],
                      ),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                    ),
                     /**/

                  Container(
                    height: MediaQuery.of(context).size.height-148,
                    padding: EdgeInsets.only(left:10,bottom: 0, right:10,top:0),
                    child: FutureBuilder(
                      future: fetch_trailers(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        print(snapshot.data);
                        if(snapshot.data!=null) {
                          return StaggeredGridView.countBuilder(
                            itemCount: snapshot.data.length,
                            staggeredTileBuilder: (_)=>StaggeredTile.fit(2),
                            crossAxisCount: 2,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 8,
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                color: Colors.black87,
                                child:  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>Video(snapshot.data[index])));
                                  },
                                  child: Card(
                                    color: Colors.black12,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)
                                    ),
                                    elevation: 10,
                                    margin: EdgeInsets.zero,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(color: Colors.grey,
                                          margin: EdgeInsets.all(5),
                                          child: ClipRect(
                                            child: FadeInImage.assetNetwork(
                                                placeholder: "assets/loader.gif",

                                              image: snapshot.data[index].cover,fit: BoxFit.cover,
                                              height: 170,
                                               width: MediaQuery.of(context).size.width,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top:5,bottom: 10,left: 10,right: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data[index].title,style: TextStyle(fontSize: 17,color: Colors.orange,fontWeight: FontWeight.bold),),
                                              Text(snapshot.data[index].description,style: TextStyle(fontSize: 12,color: Colors.grey),maxLines: 3,overflow: TextOverflow.fade,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: 5,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemSize: 15,
                                                    itemCount: 5,
                                                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 7,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                  Icon(Icons.favorite_border_sharp,size: 14,)
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );

                              },
                          );
                        }else{
                          return Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              height: 50,
                                child: Shimmer.fromColors(
                                  enabled: true,
                                    baseColor:Colors.black!,
                                    highlightColor:Colors.grey[100]!,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30,),
                                        shimmerCard(),
                                        SizedBox(height: 15,),
                                        shimmerCard(),
                                        SizedBox(height: 15,),
                                        shimmerCard(),
                                      ],
                                    )
                                )
                            ),
                          );
                        }
                      }
                    ),
                  ),
                ],
              ),
                Positioned(
                  left: (MediaQuery.of(context).size.width/2)-30,
                  top: 80,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightGreenAccent,
                          spreadRadius: 1,
                          blurRadius: 15
                        )
                      ],
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text("Trailers",style: TextStyle(color: Colors.white),),
                  ),
                ),
      ]
            ),
          ),
        ),
      ),
    );


  }
  Widget shimmerCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black
      ),
      height: 200,
      width: MediaQuery.of(context).size.width-10,
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.black,
          ),
          Container()
        ],
      ),

    );
  }
}
