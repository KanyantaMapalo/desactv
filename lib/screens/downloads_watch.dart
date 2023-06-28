import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:desactvapp3/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/db_ops.dart';
import '../services/notification_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


/// Stateful widget to fetch and then display video content.
class DVideo extends StatefulWidget {
  MovieModel movie;
  DVideo(this.movie);

  @override
  _DVideoState createState() => _DVideoState();
}

class _DVideoState extends State<DVideo> {
  late VideoPlayerController _controller;
  bool  isCotrollsShow = false;
  bool isPortrait = true;
  bool isFavorite = true;
  bool downloading = false;
  String downloadprogress = "";
  DBOPS dbops = DBOPS();

  bool isloop = false;
  double _seekvalue = 0.0;
  @override
  void initState() {
    super.initState();
    final File file = File(widget.movie.url);


    _controller = VideoPlayerController.file(file)..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() async{
          _controller.play();
          updatePlaying();

          await notificationService.showLocalNotification(
              id: 0,
              title: "Playing: ${widget.movie.title}",
              body: "Description: ${widget.movie.description}",
              payload: widget.movie.cover
          );



        });
      });
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();

    super.initState();
  }
  late final NotificationService notificationService;

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()));
      });

  GetStorage storage = GetStorage();
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    print("PRINT: "+_controller.value.duration.inSeconds.toDouble().toString());
    Future<List<MovieModel>>getDownloads()async{
      List<MovieModel> list = [];

      if(storage.read("downloads")!=null){
        for(var movie in storage.read("downloads")){
          MovieModel move = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["cover"], movie["url"].toString(), movie["id"], movie["duration"], "","",movie['type']);

          list.add(move);

        }
      }

      return list;
    }

    _controller.setLooping(isloop);

    Wakelock.enable();
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
            children: [
              Stack(
                  children: [
                    Container(
                      height: 250,
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      child:
                      _controller.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isCotrollsShow=true;
                              });

                              onControllShow();
                            },
                            child: VideoPlayer(_controller)
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("${widget.movie.cover}"),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.grey,),
                        ),
                      ),
                    ),
                    isCotrollsShow?GestureDetector(
                      onTap: (){
                        if(isCotrollsShow==true){
                          setState(() {
                            isCotrollsShow=false;
                          });
                        }else{
                          setState(() {
                            isCotrollsShow=true;
                          });
                        }
                      },
                      child: Positioned(
                          child: Container(
                            height: 250,
                            color: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.share,color: Colors.white,))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(onPressed: (){}, icon:Icon(Icons.skip_previous,size: 40,color: Colors.white,)),
                                    IconButton(onPressed: (){
                                      onControllShow();
                                      setState(() {
                                        _controller.value.isPlaying?_controller.pause():_controller.play();
                                      });

                                    }, icon:Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow,size: 50,color: Colors.white,),),
                                    IconButton(onPressed: (){}, icon:Icon(Icons.skip_next,size: 40,color: Colors.white,)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(getVideoPosition().toString(),style: TextStyle(color:Colors.white,),),
                                    ),
                                    Row(
                                      children: [
                                        Switch(
                                          // thumb color (round icon)
                                          activeColor: Colors.amber,
                                          activeTrackColor: Colors.cyan,
                                          inactiveThumbColor: Colors.blueGrey.shade600,
                                          inactiveTrackColor: Colors.grey.shade400,
                                          splashRadius: 50.0,
                                          // boolean variable value
                                          value: isloop,
                                          // changes the state of the switch
                                          onChanged: (value){
                                            setState(() {
                                              isloop = value;
                                            });}
                                        ),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.settings)),

                                        IconButton(onPressed: (){pushFullScreenVideo();}, icon: Icon(Icons.fullscreen),color: Colors.white,)
                                      ],
                                    )

                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                    ):Container(),
                  ]
              ),
              SizedBox(
                child: Slider(
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  thumbColor: Colors.red,
                    value: _controller.value.duration.inSeconds.toDouble()==0.0?0.0:_seekvalue, onChanged: (val){
                    setState(() {
                      _seekvalue = _controller.value.duration.inSeconds.toDouble()==0.0?0.0:val;
                      _controller.seekTo(val.seconds);
                    });
                },max: _controller.value.duration.inSeconds.toDouble(),min:0.0),
              ),
              Container(
                color: Colors.black,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading:
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.play_circle_filled_outlined,color: Colors.white,),
                        ),
                        title:
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(widget.movie.title,style: TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                        subtitle:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${widget.movie.description}",style: TextStyle(color: Colors.grey,fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),

                          ],
                        ),
                        trailing:
                        Container(
                            width: 160,
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: (){
                                    _showBottomSheetLocation();
                                  },
                                ),
                                IconButton(

                                  onPressed: () async{
                                    setState(() {
                                      isFavorite=isFavorite==true?false:true;
                                    });
                                  },
                                  icon: isFavorite?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border_sharp,color: Colors.white ,),
                                ),

                              ],
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-368,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40))
                ),
                child: FutureBuilder(
                  future: getDownloads(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData) {
                      if(snapshot.data.length>0){
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),

                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                color: widget.movie.id==snapshot.data[index].id?Colors.black26:Colors.transparent,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.only(bottom: 1),
                                child: ListTile(
                                  title: Text(snapshot.data[index].title, style: TextStyle(color: widget.movie.id==snapshot.data[index].id?Colors.red:Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  subtitle: Text(snapshot.data[index].description,style:TextStyle(color: widget.movie.id==snapshot.data[index].id?Colors.white:Colors.black54),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  leading: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Stack(
                                          children: [
                                            FadeInImage(
                                              placeholder: AssetImage("assets/loader.gif"),
                                              image: AssetImage('assets/album.png'),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            snapshot.data[index].duration!="null"?Positioned(
                                              left:5,
                                              bottom:5,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal:6,vertical:2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child:Text(snapshot.data[index].duration,style:TextStyle(fontSize: 10))
                                              ),
                                            ):Text(""),
                                          ],
                                        ),
                                      ),
                                  trailing: IconButton(
                                    color: widget.movie.id==snapshot.data[index].id?Colors.red:Colors.black,
                                    icon: Icon(Icons.more_vert),
                                    onPressed: (){},
                                  ),
                                  minVerticalPadding: 10,
                                ),
                              );
                            });
                      }else{
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      }

                    }else{
                      return Center(
                          child: CircularProgressIndicator(color: Colors.grey,)
                      );
                    }
                  },
                ),
              )
            ]
        ),
      ),
    );
  }

  playPause(){

    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });


  }

  getVideoPosition() {

    var duration = Duration(milliseconds: _controller.value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }
  updatePlaying(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        getVideoPosition();
        _seekvalue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  onControllShow(){
    isCotrollsShow = true;
    print(_controller.value.isPlaying);

    if(_controller.value.isPlaying==false){
      timer = Timer(Duration(seconds: 4), () {
        setState(() {
          isCotrollsShow = false;
        });
      });
    }else{
      setState(() {
        isCotrollsShow = true;
      });

    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //NTOFICATION HANDLER


  void pushFullScreenVideo() {

//This will help to hide the status bar and bottom bar of Mobile
//also helps you to set preferred device orientations like landscape

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

//This will help you to push fullscreen view of video player on top of current page

    Navigator.of(context)
        .push(
      PageRouteBuilder(
        opaque: false,
        settings: RouteSettings(),
        pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Dismissible(
                  key: const Key('key'),
                  direction: DismissDirection.vertical,
                  onDismissed: (_){ Get.back();},
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      isPortrait = orientation == Orientation.portrait;
                      return Center(
                        child: Stack(
                          //This will help to expand video in Horizontal mode till last pixel of screen
                          fit: isPortrait ? StackFit.loose : StackFit.expand,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black,
                            ),

                            Positioned(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
              )
          );
        },
      ),
    )
        .then(
          (value) {

//This will help you to set previous Device orientations of screen so App will continue for portrait mode

            SystemChrome.setEnabledSystemUIMode(SystemUiMode.values[0]);
            SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
      },
    );
  }



  Future _showBottomSheetLocation() async{
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
              heightFactor: 0.60,
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
                                      height: 70,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(widget.movie.cover),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:9.0,top: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Title:",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                          Text(widget.movie.title,style: TextStyle(color: Colors.black),),
                                          Text("202 views", style: TextStyle(color: Colors.black,fontSize: 13))
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
                                  padding: EdgeInsets.only(top:0),
                                  child: widget.movie.producer!=""?Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Producer:",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(widget.movie.producer,style:TextStyle(color: Colors.black54),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                        ],
                                      )):Text(""),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: widget.movie.description!=""?Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Description:",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(widget.movie.description,style:TextStyle(color: Colors.black54),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                        ],
                                      )):Text(""),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              )
          );
        });
      },
    );

  }

}