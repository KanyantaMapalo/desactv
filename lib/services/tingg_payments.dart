import 'dart:convert';
import 'package:http/http.dart' as http;

class Tingg {

    String token = "";

    Future<String> authentication()async{

    var response = await http.post(Uri.parse("https://online.tingg.africa/v2/custom/oauth/token"),body:{
      "grant_type": "client_credentials",
      "client_id": "5752d72e-c339-4dbc-9c36-5569b9c03004",
      "client_secret": "Hwbvpffxzcz6MdBKq4L4YmZjhhta2MPCYnpCCzSS"
    } );

    var jsoned = json.decode(response.body);

    /*print(jsoned["access_token"].toString());*/
    token = jsoned["access_token"];
    return response.body;
  }
    Future<String> initCharge(price,firstname,lastname,email,phone,user,duration)async{
  var url ='https://online.tingg.africa/v2/custom/requests/initiate';

  Map data = {
    "merchantTransactionID": '${user}?advanced_${duration}/${DateTime.now().millisecondsSinceEpoch}',
    "requestAmount": "1",
    "currencyCode": "ZMW",
    "accountNumber": '${DateTime.now().millisecondsSinceEpoch}',
    "serviceCode": "DYNASTY",
    "dueDate": '${DateTime.now().add(const Duration(minutes: 10))}',
    "requestDescription": "Getting service/good x",
    "countryCode": "ZM",
    "customerFirstName": firstname,
    "customerLastName": lastname,
    "MSISDN": '26${phone}',
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

  print("${response.body}");
  return response.body;

  }
    Future<String> postCharge(transactionID,checkoutRequestID,phone,amount,currency,payerModeId)async{
  var url ='https://online.tingg.africa/v2/custom/requests/charge';

  Map data = {
    "merchantTransactionID": transactionID,
    "checkoutRequestID": checkoutRequestID,
    "chargeMsisdn": '26${phone}',
    "chargeAmount": amount,
    "currencyCode": currency,
    "payerModeID": payerModeId,
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

  print("${response.body}");
  return response.body;

  }
    Future<String> queryStatus(userid) async{
    var response = await http.post(Uri.parse('https://desaczm.com/backend/checksub.php'),body: {"userid":userid});

    return response.body;

  }

}