import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class TinggDown {

    String token = "";

    String transactionID = "";
    String checkoutRequestID = "";
    String amount = "";
    String currency = "";

    Future<List> authentication(price,firstname,lastname,email,phone,user,duration,payerModeID)async{

      var response = await http.post(Uri.parse("https://online.tingg.africa/v2/custom/oauth/token"),body:{
        "grant_type": "client_credentials",
        "client_id": "5752d72e-c339-4dbc-9c36-5569b9c03004",
        "client_secret": "Hwbvpffxzcz6MdBKq4L4YmZjhhta2MPCYnpCCzSS"
      } );

      var jsoned = json.decode(response.body);

      /*print(jsoned["access_token"].toString());*/
      token = jsoned["access_token"];
      var result = await initCharge(price,firstname,lastname,email,phone,user,duration,payerModeID);
      return result;
    }

    var user_phone;

    Future<List> initCharge(price,firstname,lastname,email,phone,user,duration,payerModeID)async{
      user_phone = phone;

      var url ='https://online.tingg.africa/v2/custom/requests/initiate';

      Map data = {
        "merchantTransactionID": '${user}?advanced_${duration}/${DateTime.now().millisecondsSinceEpoch}',
        "requestAmount": "${price}",
        "currencyCode": "ZMW",
        "accountNumber": '${DateTime.now().millisecondsSinceEpoch}',
        "serviceCode": "DYNASTY",
        "dueDate": '${DateTime.now().add(const Duration(minutes: 10))}',
        "requestDescription": "Getting service/good x",
        "countryCode": "ZM",
        "customerFirstName": firstname,
        "customerLastName": lastname,
        "MSISDN": '260${user_phone}',
        "customerEmail": '$email',
        "paymentWebhookUrl": "https://desaczm.com/subscription/webhook/new_webhook.php",
        "successRedirectUrl": "https://desaczm.com/dashboard/index.php",
        "failRedirectUrl": "https://desaczm.com/subscription/"
      };
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(url as Uri,
          headers: {
            "Authorization": token,
            "Content-Type": "application/json",
          },
          body: body
      );

      var jsoned = json.decode(response.body);

      transactionID = jsoned["results"]["merchantTransactionID"];
      checkoutRequestID = jsoned["results"]["checkoutRequestID"].toString();
      amount = jsoned["results"]["requestAmount"].toString();
      currency = jsoned["results"]["originalCurrencyCode"];
     // payerModeId = payerModeID;
      print("REQUEST: ${json.encode(response.body)}");
      postCharge();


      return [transactionID,token,checkoutRequestID];
    }
    Future<String> postCharge()async{
      var url ='https://online.tingg.africa/v2/custom/requests/charge';

      Map data = {
        "merchantTransactionID": transactionID,
        "checkoutRequestID": checkoutRequestID,
        "chargeMsisdn": '260${user_phone}',
        "chargeAmount": amount,
        "currencyCode": currency,
        "payerModeID": GetStorage().read("payermodeid"),
        "languageCode": "en"
      };
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(url as Uri,
          headers: {
            "Authorization": token,
            "Content-Type": "application/json",
          },
          body: body
      );

      print("POST CHARGE:  ${json.encode(response.body)}");
      return response.body;

    }
    Future queryStatus(txid,token1,checkoutRequestID1)async{

      var response = await http.post(Uri.parse('https://online.tingg.africa/v2/custom/requests/query-status'),
          headers: {
            "Authorization": token1,
            "Content-Type": "application/json",
          },
        body: json.encode({
          "merchantTransactionID":"${txid}",
          "serviceCode":"DYNASTY",
          "checkoutRequestID":"${checkoutRequestID1}"
        })
      );

      return response.body;

    }

}