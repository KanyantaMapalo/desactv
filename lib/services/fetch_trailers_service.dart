import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';


Future<List<MovieModel>> fetch_trailers() async{
  List<MovieModel> trailersList = [];

  var response = await http.get(Uri.parse("http://desaczm.com/app_backend/fetch_trailers.php"));
  var jsonParsed = json.decode(response.body);

    for(var trailer in jsonParsed["trailers"]){
      MovieModel movie = MovieModel(trailer["title"].toString(), trailer["description"].toString(), trailer["cpath"].toString(), trailer["vpath"].toString(), trailer["vid"].toString(),trailer["duration"].toString(),trailer["producer"].toString(),trailer["views"].toString(),trailer["type"]);
      trailersList.add(movie);
    }
    print(trailersList.toString()+"TRAILER HERE");
  return trailersList;
}