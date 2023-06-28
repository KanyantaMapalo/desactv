import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class PaymentOptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Option:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                PaymentOptionItem(
                  icon: Image.asset('assets/airtel.png',width: 60,height: 50,fit: BoxFit.cover,),
                  title: 'Airtel',
                  onTap: () {
                    // Handle Airtel Money payment option selection
                    GetStorage().write("payermodeid","334");
                    Get.updateLocale(Locale("EN"));
                  },
                ),
                GetStorage().read("payermodeid")=="334"?Positioned(
                  left: 20,
                  top: 10,
                  child: Icon(Icons.thumb_up_alt_rounded, size: 40, color: Colors.black),
                ):Container(),
              ],
            ),
            SizedBox(width: 20),
            Stack(
              children: [
                PaymentOptionItem(
                icon: Image.asset('assets/mtn.png',width: 60,height: 50,fit: BoxFit.cover,),
                title: 'MTN',
                onTap: () {
                  // Handle MTN Mobile Money payment option selection
                  GetStorage().write("payermodeid","293");
                  Get.updateLocale(Locale("EN"));
                },
              ),
                GetStorage().read("payermodeid")=="293"?Positioned(
                  left: 20,
                  top: 10,
                  child: Icon(Icons.thumb_up_alt_rounded, size: 40, color: Colors.black),
                ):Container(),
              ],

            ),
            SizedBox(width: 20),
            Stack(
              children: [
                PaymentOptionItem(
                  icon: Image.asset('assets/zamtel.png',width: 60,height: 50,fit: BoxFit.cover,),
                  title: 'Zamtel',
                  onTap: () {
                    GetStorage().write("payermodeid","335");
                    Get.updateLocale(Locale("EN"));
                  },
                ),
                GetStorage().read("payermodeid")=="335"?Positioned(
                  left: 20,
                  top: 10,
                  child: Icon(Icons.thumb_up_alt_rounded, size: 40, color: Colors.black),
                ):Container(),
            ],

            ),
          ],
        ),
      ],
    );
  }
}
class PaymentOptionItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const PaymentOptionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            icon,
          ],
        ),
      ),
    );
  }
}
