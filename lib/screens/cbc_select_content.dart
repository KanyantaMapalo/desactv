import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desactvapp3/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


import '../services/db_ops.dart';
import 'date_cbc_set.dart';

class CBContentSelect extends StatefulWidget {
  const CBContentSelect({Key? key}) : super(key: key);

  @override
  State<CBContentSelect> createState() => _CBContentSelectState();
}

class _CBContentSelectState extends State<CBContentSelect> {
  int _select_value = 0;
  List _selectedItems = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _showStartDatePicker() {
    /*DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2100),
      onChanged: (date) {
        setState(() {
          _startDate = date;
        });
      },
      onConfirm: (date) {
        setState(() {
          _startDate = date;
        });
      },
      currentTime: _startDate ?? DateTime.now(),
      locale: LocaleType.en,
    );*/
  }

  void _showEndDatePicker() {
  /*  DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2100),
      onChanged: (date) {
        setState(() {
          _endDate = date;
        });
      },
      onConfirm: (date) {
        setState(() {
          _endDate = date;
        });
      },
      currentTime: _endDate ?? DateTime.now(),
      locale: LocaleType.en,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Content"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: DBOPS().fetchAllMusic(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data?.length!=0){
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context,index){
                            return RadioListTile(
                                title: Text(snapshot.data![index].title, style: TextStyle(color: Colors.white),),
                                value: _selectedItems.indexWhere((element)=>element["id"]==snapshot.data![index].id)==-1?1:0,
                                groupValue: 0,
                                toggleable: true,
                                selected:  _selectedItems.indexWhere((element)=>element["id"]==snapshot.data![index].id)==-1?false:true,
                                onChanged: (value) {
                                    setState(() {

                                      if(_selectedItems.indexWhere((element)=>element["id"]==snapshot.data![index].id)==-1){
                                        _selectedItems.add(
                                          {
                                            "id":snapshot.data![index].id,
                                            "cover":snapshot.data![index].cover,
                                            "title":snapshot.data![index].title,
                                            "description":snapshot.data![index].description,
                                            "views":snapshot.data![index].views,
                                            "url":snapshot.data![index].url
                                          }
                                        );
                                      }else{
                                        _selectedItems.removeWhere((element) => element["id"] == snapshot.data![index].id);
                                      }
                                    });
                                },
                            );
                        });
                      }else{
                        return Container();
                      }
                    }else{
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  },

              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  _selectedItems.length>0?ElevatedButton(onPressed: (){

                    Get.to(()=>DateRangePickerScreen(_selectedItems));

                  }, child: Text("Add ${_selectedItems.length} songs")):ElevatedButton(onPressed: (){

                  }, child: Text("Add ${_selectedItems.length} songs",style: TextStyle(color: Colors.grey),))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
