import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/credentials.dart';
class Airtel{

  AirtelCreds credentials = AirtelCreds();

  String token = "";


  Future<String> authentication() async{
    var headers = {
      'Content-Type':'application/json',
      'Accept':'*/*'
    };

    var body = json.encode({
      "grant_type": "client_credentials",
      "client_id": "af763e68-eb22-449b-abb6-b0c335170862",
      "client_secret": "****************************"
    });

    http.post(Uri.parse("${credentials.productionBaseURL}${credentials.fetchAccessTokenURL}"),
        body:body,
        headers: headers
    ).then((value){
      var jsoned = json.decode(value.body);

      print(value.statusCode);
      print(value.body);
      token = jsoned["access_token"];
    }).catchError((e){
      print(e);
    });


    return "";
  }



}