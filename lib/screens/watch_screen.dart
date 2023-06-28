import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:desactvapp3/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:widget_loading/widget_loading.dart';
import '../controller/login.dart';
import '../services/db_ops.dart';
import '../services/notification_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../services/tingg_down.dart';
import '../services/tingg_payments.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../customs/payment_options.dart';



/// Stateful widget to fetch and then display video content.
class Video extends StatefulWidget {
  MovieModel movieItem;
  Video(this.movieItem);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;
  bool  isCotrollsShow = false;
  bool isPortrait = true;
  bool isFavorite = true;
  bool downloading = false;
  bool isDownloaded = false;

  var backMovies = [];
  var playlist = [];
  TextEditingController txtPhone = TextEditingController();
  String cc = "";
  String code = "";
  String payermodeid = "";
  String downloadprogress = "0";
  DBOPS dbops = DBOPS();
  int count = 10;
  Timer? timer;
  Timer? timer1;
  Future getBackMovies()async{
    playlist = await dbops.fetchBottomContent(widget.movieItem.id);
    backMovies = await dbops.fetchAllMovies("drama");
  }

  GetStorage storage = GetStorage();
  bool showMiniPlayer = false;
  int _selecteditem = 0;
  ScrollController _scrollController = ScrollController();
  double seekvalue = 0.0;

  int playingIndex = 0;
  bool show_next = false;


  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    getBackMovies();
    GetStorage().write("payermodeid", "");
    String conc = widget.movieItem.url[0]=="."?"https://desaczm.com/":"htt";
    _controller = VideoPlayerController.network(
        '$conc${widget.movieItem.url.substring(3,widget.movieItem.url.length)}')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() async{

          _controller.play();
          dbops.view(Get.find<LoginController>().userdets.value.first.userID, widget.movieItem.id);
          updatePlaying();

          await notificationService.showLocalNotification(
              id: 0,
              title: "Playing: ${widget.movieItem.title}",
              body: "Description: ${widget.movieItem.description}",
              payload: widget.movieItem.cover
          );

        });
      });
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    // Set the overlay style
    _phoneNumberController = TextEditingController();
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

  void playVideo(MovieModel video) {
    _controller.pause(); // Pause the current video
    _controller = VideoPlayerController.network(video.url)
      ..initialize().then((_) async{
        playlist = await dbops.fetchBottomContent(widget.movieItem.id);
        setState(() {
          _controller.play();
          if(storage.read("downloads")!=null){

            for(var move in storage.read("downloads")){
              if(widget.movieItem.id == move["id"]){
                isDownloaded = true;
              }else{
                isDownloaded = false;
              }
            }
          }

        });
        updatePlaying();
      });
    dbops.view(Get.find<LoginController>().userdets.value.first.userID, widget.movieItem.id);

  }
  void playNext(){
    for(int i = 0; i<playlist.length; i++){
      if(playlist[i].id == widget.movieItem.id){
        if(i<playlist.length){
          playVideo(playlist[++i]);
          widget.movieItem = playlist[i];
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent + (i * 90),
            duration: Duration(milliseconds: 500), // Duration of the scroll animation
            curve: Curves.easeInOut, // Easing curve for the scroll animation
          );

          if(!_controller.value.isInitialized){
            setState(() {
              show_next = false;
            });
          }
        }
      }
    }
  }
  void playPrevious(){
    for(int i = 0; i<playlist.length; i++){
      if(playlist[i].id == widget.movieItem.id){
        if(i!=0){
          playVideo(playlist[--i]);
          widget.movieItem = playlist[i];
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent + (i * 90),
            duration: Duration(milliseconds: 500), // Duration of the scroll animation
            curve: Curves.easeInOut, // Easing curve for the scroll animation
          );
        }
      }
    }
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if(storage.read("downloads")!=null){

      for(var move in storage.read("downloads")){
        if(widget.movieItem.id == move["id"]){
          isDownloaded = true;
        }
      }
    }
    Wakelock.enable();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (!showMiniPlayer) Dismissible(
              key: Key("player"),
              onDismissed: (_) {
                setState(() {
                  showMiniPlayer = true;

                });
              },
              background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backtrailer.jpeg"),
                  fit: BoxFit.cover
                )
              ),
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.black87,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(itemBuilder: (context,index){
                  return Card(
                    elevation: 20,
                    child: Container(
                      child: Row(
                        children: [

                         Container(
                            width: MediaQuery.of(context).size.width-158,
                            padding: EdgeInsets.all(20),
                            child: Text(backMovies[index].title,style: TextStyle(fontSize: 19),overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                   )
                  )
                );
              },itemCount: backMovies.length),
              )
            ),
              direction: DismissDirection.down,
              child: Scaffold(
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
                                      onHorizontalDragEnd: (DragEndDetails details) {
                                        if (details.velocity.pixelsPerSecond.dx > 0) {
                                          // Swiped right
                                          playNext();
                                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                                          // Swiped left
                                          playPrevious();
                                        }
                                      },
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
                                          image: NetworkImage("${widget.movieItem.cover}"),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  child: Center(
                                    child: WiperLoading(
                                        loading: true,
                                        wiperColor: Colors.black12,
                                        child: Container(),

                                    ),
                                  ),
                                ),
                              ),
                              _controller.value.isBuffering?Positioned(
                                child: Center(
                                  child: WiperLoading(
                                    loading: true,
                                    wiperColor: Colors.black12,
                                    child: Container(),

                                  ),
                                ),
                              ):Container(),
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
                                              IconButton(onPressed: (){
                                                playPrevious();
                                              }, icon:Icon(Icons.skip_previous,size: 40,color: widget.movieItem.id==playlist[0].id?Colors.grey.shade900:Colors.white,)),
                                              IconButton(onPressed: (){
                                                onControllShow();
                                                setState(() {
                                                  _controller.value.isPlaying?_controller.pause():_controller.play();
                                                });

                                              }, icon:Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow,size: 50,color: Colors.white,),),
                                              IconButton(onPressed: (){
                                                playNext();
                                              }, icon:Icon(Icons.skip_next,size: 40,color: widget.movieItem.id==playlist[playlist.length-1].id?Colors.grey.shade900:Colors.white,)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(getVideoPosition().toString(),style: TextStyle(color:Colors.white,),),
                                              ),
                                              IconButton(onPressed: (){pushFullScreenVideo();}, icon: Icon(Icons.fullscreen),color: Colors.white,)
                                            ],
                                          ),
                                          SizedBox(height: 1)
                                        ],
                                      ),
                                    )
                                ),
                              ):Container(),
                              isCotrollsShow?Positioned(
                                bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 4.0,
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                                      trackShape: RoundedRectSliderTrackShape(),
                                    ),
                                    child: Slider(
                                      value: _controller.value.position.inMilliseconds.toDouble(),
                                      min: 0.0,
                                      max: _controller.value.duration.inMilliseconds.toDouble(),
                                      onChanged: (value) {
                                        setState(() {
                                          // Calculate the new position based on the slider value
                                          Duration newPosition = Duration(milliseconds: value.round());
                                          _controller.seekTo(newPosition);
                                        });
                                      },
                                      activeColor: Colors.red,
                                      inactiveColor: Colors.grey,
                                    ),
                                  ) ):Container(),
                              show_next?Positioned(
                                bottom: 30,
                                left: 10,
                                child: GestureDetector(
                                  onTap: (){
                                    setState((){
                                      playVideo(playlist[playlist.indexWhere((item) => item.id == widget.movieItem.id)+1]);
                                      widget.movieItem = playlist[playlist.indexWhere((item) => item.id == widget.movieItem.id)+1];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text("NEXT", style: TextStyle(shadows: [Shadow(color: Colors.black,offset: Offset(1.0,1.0)),Shadow(color: Colors.black),Shadow(color: Colors.black)]),),
                                      Container(
                                        width: 150,
                                        height: 100,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(playlist[playlist.indexWhere((item) => item.id == widget.movieItem.id)+1].cover),
                                            fit: BoxFit.cover
                                          )
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(playlist[playlist.indexWhere((item) => item.id == widget.movieItem.id)+1].title, style: TextStyle(shadows: [Shadow(color: Colors.black,offset: Offset(1.0,1.0)),Shadow(color: Colors.black),Shadow(color: Colors.black)]),maxLines: 3,overflow: TextOverflow.ellipsis)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):Container()
                            ]
                        ),
                        Container(
                          color: Colors.black,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  leading:
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.play_circle_filled_outlined,color: Colors.white,),
                                  ),
                                  title:
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width-(26+20),
                                    child: Text(widget.movieItem.title,style: TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                  subtitle:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("${widget.movieItem.views} views",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                    ],
                                  ),
                                  trailing:
                                  Container(
                                      width: 160,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_drop_down),
                                            onPressed: (){
                                              _showBottomSheetLocation(widget.movieItem);
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

                                          widget.movieItem.type=="music"?(downloading?Stack(children: [Positioned(left:3,top:10,child: Center(child: Container(child: Text("${downloadprogress}%",style:TextStyle(fontSize: 13))),)),CircularProgressIndicator(value:(double.parse(downloadprogress)/100))]):(!isDownloaded?IconButton(
                                            color: Colors.green,
                                            onPressed: () async{
                                              Get.bottomSheet(
                                                  StatefulBuilder(
                                                    builder: (context,state){
                                                      return Container(
                                                        height: MediaQuery.of(context).size.height*0.59,
                                                        padding: EdgeInsets.all(20),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white
                                                        ),
                                                        child: SingleChildScrollView(
                                                          child: Stack(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                        child:Text("Pay to download", style: TextStyle(fontSize: 16,color: Colors.teal, fontWeight: FontWeight.bold))
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text("Pay: ", style: TextStyle(color: Colors.red)),
                                                                            Text("K10", style: TextStyle(color: Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.music_video_outlined, color: Colors.red,),
                                                                            SizedBox(width: 10,),
                                                                            Text(widget.movieItem.title, style: TextStyle(color: Colors.teal),)
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        PaymentOptionsWidget(),

                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 15),
                                                                    TextField(
                                                                      controller: txtPhone,
                                                                      style: TextStyle(
                                                                          color: Colors.blue,
                                                                          fontSize: 17
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        filled: true,
                                                                        fillColor: Colors.black12,
                                                                        suffix: SizedBox(
                                                                          height: 30,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(Colors.green),
                                                                            ),
                                                                            onPressed: ()async{

                                                                                  if(GetStorage().read("payermodeid")==""){
                                                                                    Get.snackbar("Error", "Select payment option");
                                                                                  }else{
                                                                                    if(txtPhone.text==""){
                                                                                      Get.snackbar("Error", "Enter Phone number");
                                                                                     }else{
                                                                                      setState((){
                                                                                        _loading = true;
                                                                                      });
                                                                                      var result = await TinggDown().authentication("10", Get.find<LoginController>().userdets.value.first.firstname, Get.find<LoginController>().userdets.value.first.lastname, Get.find<LoginController>().userdets.value.first.email,txtPhone.text,Get.find<LoginController>().userdets.value.first.userID,"download",GetStorage().read("payermodeid"));

                                                                                      Timer.periodic(Duration(seconds: 5), (Timer time) async{

                                                                                        if(count>5){
                                                                                          var res = await TinggDown().queryStatus(result[0],result[1],result[2]);
                                                                                          var jsone = json.decode(res);
                                                                                          print(jsone);
                                                                                          setState(() {
                                                                                            _loading = false;
                                                                                            Get.updateLocale(Locale("en"));
                                                                                          });
                                                                                        }else{
                                                                                          timer1?.cancel();
                                                                                        }
                                                                                        count--;
                                                                                      });


                                                                                    }
                                                                                  }
                                                                                   Get.updateLocale(Locale("EN"));

                                                                            },
                                                                            child: Text("pay", style: TextStyle(color: Colors.white),),
                                                                          ),
                                                                        ),
                                                                        prefixIcon: CountryCodePicker(
                                                                          onChanged: (value) {
                                                                            // Handle the country code change here
                                                                            code = value.toString();

                                                                          },
                                                                          dialogTextStyle: TextStyle(color: Colors.white),
                                                                          dialogBackgroundColor: Colors.blueGrey,
                                                                          barrierColor: Colors.black12,
                                                                          initialSelection: 'ZM',
                                                                          favorite: ['ZM'],
                                                                          showCountryOnly: false,
                                                                          showOnlyCountryWhenClosed: false,
                                                                          padding: EdgeInsets.only(bottom: 0),
                                                                          textStyle: TextStyle(fontSize: 17),
                                                                        ),
                                                                        labelStyle: TextStyle(
                                                                            color: Colors.black
                                                                        ),
                                                                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(8.0), // Sets rounded corners
                                                                          borderSide: BorderSide(color: Colors.blue, width: 2.0), // Sets border color and width
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                _loading?Center(
                                                                  child: Positioned(
                                                                    top: 0,
                                                                    left: 0,
                                                                    child: Container(
                                                                        height: 300,
                                                                        width: 300,
                                                                        child: CircularWidgetLoading(
                                                                            dotRadius: 5.0,
                                                                            dotColor: Colors.green,
                                                                            maxLoadingCircleSize: 50,
                                                                            child: Container()
                                                                        )
                                                                    ),
                                                                  ),
                                                                ):Container(),
                                                              ]
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                              );
                                              //downloadBook();
                                            },
                                            icon: Icon(Icons.download),
                                          ):Icon(Icons.download_done))):Icon(Icons.download, color: Colors.grey),
                                        ],
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height-354,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/backtrailer.jpeg"),fit: BoxFit.cover),
                              color: Colors.white70,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40))
                          ),
                          child:  ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.zero,
                                      physics: BouncingScrollPhysics(),
                                      itemExtent: 90,
                                      itemCount: playlist.length,
                                      itemBuilder: (context, int index) {
                                        return Container(
                                          width: MediaQuery.of(context).size.width,
                                          color: Colors.black87,
                                          padding: EdgeInsets.all(3),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    setState((){
                                                      playVideo(playlist[index]);
                                                      widget.movieItem = playlist[index];
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 150,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        FadeInImage(
                                                          placeholder: AssetImage("assets/loader.gif"),
                                                          image: NetworkImage(playlist[index].cover),
                                                          height: 100,
                                                          width: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Positioned(
                                                          left:5,
                                                          bottom:5,
                                                          child: Container(
                                                              padding: EdgeInsets.symmetric(horizontal:6,vertical:2),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.black87,
                                                                  borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              child:Text(playlist[index].duration,style:TextStyle(fontSize: 10))
                                                          ),
                                                        ),
                                                        playlist[index].id==widget.movieItem.id?Positioned(
                                                          bottom: 5,
                                                          right: 5,
                                                          child: Icon(Icons.play_circle_filled)
                                                        ):Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width-160,
                                                  padding: EdgeInsets.all(15),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState((){
                                                            playVideo(playlist[index]);
                                                            widget.movieItem = playlist[index];
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 122,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  playlist[index].title,
                                                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                                                                  overflow: TextOverflow.ellipsis
                                                                ),
                                                                Text(playlist[index].description,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),)

                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                      PopupMenuButton<String>(
                                                        elevation: 20,
                                                        shape: RoundedRectangleBorder(),
                                                        color: Colors.black,
                                                        icon: Icon(Icons.more_vert,color: Colors.white,),
                                                        onSelected: (value) {
                                                          switch(value){
                                                            case 'play':
                                                              setState((){
                                                                playVideo(playlist[index]);
                                                                widget.movieItem = playlist[index];
                                                              });
                                                              break;
                                                            case 'playing':
                                                              _controller.play();
                                                              break;
                                                            case 'pause':
                                                              _controller.pause();
                                                              break;
                                                            case 'download':
                                                              isDownloaded?print('downloaded'):downloadBook();
                                                              break;

                                                          }
                                                        },
                                                        itemBuilder: (BuildContext context) {
                                                          // Define the menu items
                                                          return [
                                                            PopupMenuItem<String>(
                                                              value: widget.movieItem.id == playlist[index].id?(_controller.value.isPlaying?'pause':'playing'):'play',
                                                              child: Row(
                                                                  children: [
                                                                    widget.movieItem.id == playlist[index].id?(_controller.value.isPlaying?Icon(Icons.pause,color: Colors.red,):Icon(Icons.play_arrow,color: Colors.red,)):Icon(Icons.play_arrow,color: Colors.red,),
                                                                    widget.movieItem.id == playlist[index].id?(_controller.value.isPlaying?Text('pause'):Text('play')):Text('play')
                                                                  ]
                                                              ),
                                                            ),
                                                            PopupMenuItem<String>(
                                                              value: 'download',
                                                              child: Row(
                                                                  children: [
                                                                    Icon(Icons.download,color: isDownloaded?Colors.grey:Colors.green,),
                                                                    Text('download',style: TextStyle(color: isDownloaded?Colors.grey:Colors.white),)
                                                                  ]
                                                              ),

                                                            ),
                                                          ];
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                            },
                          ),
                        )
                      ]
                  ),
                ),
              ),),
            if (showMiniPlayer) Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/backtrailer.jpeg"),
                        fit: BoxFit.cover
                      )
                    ),
                    height: MediaQuery.of(context).size.height-124,
                    child: Container(
                      color: Colors.black87,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          BottomNavigationBar(
                            currentIndex: _selecteditem,
                            onTap: (item){
                             setState(() async{
                               _selecteditem = item;
                               switch(item){
                                 case 0:
                                    getBackMovies();
                                    break;
                                 case 1:
                                   backMovies = await dbops.fetchFewMusic();
                                   break;
                                 case 2:
                                   backMovies = await dbops.fetchFetchDocumentariesTalkshow();
                                   break;

                               }
                             });
                            },
                              items: [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.movie),
                              label: "Movies"
                            ),
                            BottomNavigationBarItem(icon: Icon(Icons.music_video),
                                label: "Music"
                            ),
                            BottomNavigationBarItem(icon: Icon(Icons.history_edu),
                                label: "Documentaries"
                            ),
                          ]),
                          Container(
                            height: MediaQuery.of(context).size.height-182,
                            child: ListView.builder(
                                itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    playVideo(backMovies[index]);
                                    widget.movieItem = backMovies[index];
                                  });

                                },
                                child: Card(
                                  elevation: 20,
                                  color: Colors.black,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                            image: DecorationImage(
                                                image: NetworkImage(backMovies[index].cover),
                                              fit: BoxFit.cover
                                            )
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width-158,
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(backMovies[index].title,style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                              Text(backMovies[index].description, maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.remove_red_eye, size: 18,),
                                                    Text(" "+backMovies[index].views)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                        ,
                                      ],
                                    )
                                  )
                                ),
                              );
                            },itemCount: backMovies.length),
                          ),
                        ],
                      ),
                    )
                  ),
                  Dismissible(
                    background: Container(
                        color: Colors.black
                    ),
                    direction: DismissDirection.up,
                    onDismissed: (e){
                        setState(() {
                          showMiniPlayer = false;
                        });
                     },
                    key: Key(""),
                    confirmDismiss: (di)async{
                      setState(() {
                        showMiniPlayer = false;
                      });
                      return false;
                    },
                    child: Container(
                      height: 100,
                      color: Colors.black87,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                showMiniPlayer = false;
                              });
                            },
                            child: Container(
                              height: 100,
                              width: 120,
                              color: Colors.black,
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
                                        image: NetworkImage("${widget.movieItem.cover}"),
                                        fit: BoxFit.cover
                                    )
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(color: Colors.grey,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width-205,
                              child: Text('${widget.movieItem.title}', softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1,)),
                          _controller.value.isPlaying?IconButton(
                            onPressed: () {
                              _controller.pause();
                            },
                            icon: Icon(Icons.pause, size: 30,),
                          ):IconButton(
                            onPressed: () {
                              _controller.play();
                            },
                            icon: Icon(Icons.play_arrow, size: 30,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    Duration currentPosition = _controller.value.position;
    Duration totalDuration = _controller.value.duration;
    Duration remainingTime = totalDuration - currentPosition;


    if(remainingTime.inSeconds<=10&&remainingTime.inSeconds>0){
      if((playlist.indexWhere((element) => element.id == widget.movieItem.id)) == playlist.length-1){

      }else{
        setState(()=>show_next=true);
      }

    }else{
      setState(()=>show_next=false);
    }

    if(remainingTime.inSeconds==1){
      setState(()=>show_next=false);
      playNext();
    }



    return [duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');

  }
  updatePlaying(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        getVideoPosition();
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
    _scrollController.dispose();
    _phoneNumberController.dispose();
    timer?.cancel();
  }

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
  Future _showBottomSheetLocation(MovieModel movieItem) async{
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
                                              image: NetworkImage(movieItem.cover),
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
                                          Text(movieItem.title,style: TextStyle(color: Colors.black),),
                                          Text("${movieItem.views} views", style: TextStyle(color: Colors.black,fontSize: 13))
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
                                  child: movieItem.producer!=""?Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Producer:",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(movieItem.producer,style:TextStyle(color: Colors.black54),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                        ],
                                      )):Text(""),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: movieItem.description!=""?Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Description:",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(movieItem.description,style:TextStyle(color: Colors.black54),overflow: TextOverflow.ellipsis,maxLines: 3,),
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
  Future<void>pushDownload(directory)async{
    String path = '${directory.path}/desDownloads/${widget.movieItem.title}.mp4';

    List<Map> downloads = [
      {
        "title":widget.movieItem.title,
        "id":widget.movieItem.id,
        "cover":widget.movieItem.cover,
        "url":path,
        "duration":widget.movieItem.duration,
        "description":widget.movieItem.description
      }
    ];


    if(storage.read("downloads")!=null){
      var downed = storage.read("downloads");
      downed.add(
          {
            "title":widget.movieItem.title,
            "id":widget.movieItem.id,
            "cover":widget.movieItem.cover,
            "url":path,
            "duration":widget.movieItem.duration,
            "description":widget.movieItem.description
          }
      );
      storage.write("downloads", downed);
      print("DEALING WITH DOWNS");
    }else{
      storage.write("downloads", downloads);
    }

  }
  Future<void> downloadBook() async{
    try{
      int counter = 0;
      Dio dio = Dio();

      final dir = await getApplicationDocumentsDirectory();


      dio.download(widget.movieItem.url, '${dir.path}/desDownloads/${widget.movieItem.title}.mp4',onReceiveProgress: (received,total){
        downloading=true;
        setState(() {
          downloadprogress = (received/total*100).toStringAsFixed(0);
          //print();


          if(downloadprogress=="100"){
            downloading=false;
            if(counter==0){
              pushDownload(dir);
              dbops.log_download(widget.movieItem.id);

            }

            counter++;
          }

        });



      });

    }catch(e){
      print(e);
    }


  }

}