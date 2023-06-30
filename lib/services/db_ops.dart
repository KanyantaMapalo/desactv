import 'dart:convert';

import 'package:desactvapp3/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/nominee_model.dart';
import '../models/subscription_model.dart';
import '../models/user_model.dart';

class DBOPS extends GetxController{
  //register operation
  Future<String> register(firstname,lastname,email,phone,country,username,password,referrercode,promocode) async{
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/register.php"),body: {
      "fname":firstname,"lname":lastname,"email":email,"phone":phone,"country":country,"username":username,"password":password,"referrercode":referrercode,"promocode":promocode
    });

    var responseJSONed = json.decode(response.body);
    print(responseJSONed["user"][0]["responseMessage"]);
    // if(responseJSONed["user"][0]["responseCode"]=="1"){
    //   Get.find<LoginController>().login(username, password);
    // }
    Get.snackbar("","",messageText:Center(child: Text(responseJSONed["user"][0]["responseMessage"])),backgroundColor: Colors.black87);
    return response.body;
  }
  //register operation
  Future<List<SubModel>> getSubscriptions() async{
    List<SubModel> list = [];

    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/get_subscription_plans.php"));
    var jsoned = json.decode(response.body);

    for(var key in jsoned){
      SubModel planitem = SubModel(key["id"].toString(), key["plan"].toString(), key["price"].toString(), key["info"].toString(), key["ads"].toString());
      list.add(planitem);
    }

    return list;
  }
  //fetch content
  Future<List<MovieModel>> fetchShortMovies()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

     for(var movie in jsoned["short_movies"]){

          MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

     list.add(movieItem);

   }

    return list;

  }
  Future<List<MovieModel>> fetchAllMovies(category)async{
    List<MovieModel> list = [];
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/allMovie_data.php"),body: {"category":category});
    var jsoned = json.decode(response.body);
    print(jsoned.toString());

    for(var movie in jsoned["audio"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    print("hi");
    print(list);
    return list;

  }
  Future<List<MovieModel>> fetchDramaMovies()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

    for(var movie in jsoned["movies_drama"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchTrailerMovies()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

    for(var movie in jsoned["trailers"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchShortFilm()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

    for(var movie in jsoned["shortfilm"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchFewMusic()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

    for(var movie in jsoned["music_gospel"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchAllMusic()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/fetch_all_music.php"));
    var jsoned = json.decode(response.body);

    for(var movie in jsoned["trailers"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["vpath"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchGospelSdaMusic()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);
    print(jsoned);
    for(var movie in jsoned["music_gospel_sda"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchHipHopMusic()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);
    print(jsoned);
    for(var movie in jsoned["music_hiphop"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchFetchDocumentariesTalkshow()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);
    print(jsoned);
    for(var movie in jsoned["talkshow_documentary"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<MovieModel>> fetchFetchDocumentariesSermon()async{
    List<MovieModel> list = [];
    var response = await http.get(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);
    print(jsoned);
    for(var movie in jsoned["sermon_documentary"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<List<NomineeModel>> fetchMacNominees(category)async{
    print(category);
    List<NomineeModel> list = [];
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/fetch_mac_nominees.php"),body:{
      "category":category
    });
    var jsoned = json.decode(response.body);

    for(var nominee in jsoned){

      NomineeModel nomineeItem = NomineeModel(nominee["id"].toString(),nominee["name"].toString(),nominee["image"].toString(),nominee['votes'].toString());

      list.add(nomineeItem);

    }

    return list;

  }
  Future<List<MovieModel>> fetchBottomContent(vid)async{
    List<MovieModel> list = [];
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/videosforbottomlist.php"),body:{
      "vid":vid
    });
    var jsoned = json.decode(response.body);

for(var movie in jsoned){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);

      list.add(movieItem);

    }
    return list;

  }
  Future<void>view(userid,vid)async{
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/view_count.php"),body:{"userid":userid,"vid":vid});
    print("RESPONSE: "+response.body);
  }
  Future<List<MovieModel>> fetchAdios()async{
    List<MovieModel> list = [];
    var response = await http.post(Uri.parse("https://desaczm.com/app_backend/home_data.php"));
    var jsoned = json.decode(response.body);

for(var movie in jsoned["audio"]){

      MovieModel movieItem = MovieModel(movie["title"].toString(), movie["description"].toString(), movie["imgURL"].toString(), movie["url"].toString(), movie["id"].toString(),movie["duration"].toString(),movie["producer"].toString(),movie["views"].toString(),movie['type']);
      list.add(movieItem);

    }
    return list;

  }
  Future<void> log_download(vid)async{
    http.post(Uri.parse("https://desaczm.com/app_backend/log_download.php"),body: {"vid":vid});
  }
  Future<String> vote_mac(user,nominee)async{
    var res = await http.post(Uri.parse("https://desaczm.com/app_backend/vote_mac.php"),body: {"useridn":user,'nominee':nominee});
    var jsonResponse = jsonDecode(res.body);
    print(jsonResponse["responseCode"]);
    return res.body;
  }

}