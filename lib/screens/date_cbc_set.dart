import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangePickerScreen extends StatefulWidget {
  @override
  _DateRangePickerScreenState createState() => _DateRangePickerScreenState();

  final items;
  DateRangePickerScreen(this.items);
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {


  DateTime _startDate =  DateTime.now();
  DateTime _endDate = DateTime.now();

  void _showStartDatePicker() {
   /* DatePicker.showDatePicker(
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
    /*DatePicker.showDatePicker(
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

  String _selectedItem = "1";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Set Dates'),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
          Container(
          padding: EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedItem??"1",
            decoration: InputDecoration(
              labelText: 'Week',
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              setState(() {
                _selectedItem = newValue!;
              });
            },
            items: [
              DropdownMenuItem(
                value: '1',
                child: Text('Week 1'),
              ),
              DropdownMenuItem(
                value: '2',
                child: Text('Week 2'),
              ),
              DropdownMenuItem(
                value: '3',
                child: Text('Week 3'),
              ),
              DropdownMenuItem(
                value: '4',
                child: Text('Week 4'),
              ),
              DropdownMenuItem(
                value: '5',
                child: Text('Week 5'),
              ),
            ],
          ),
          ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      readOnly: true,
                      onTap: _showStartDatePicker,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _startDate != null
                            ? '${_startDate.day}/${_startDate.month}/${_startDate.year}'
                            : '',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      readOnly: true,
                      onTap: _showEndDatePicker,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _endDate != null
                            ? '${_endDate.day}/${_endDate.month}/${_endDate.year}'
                            : '',
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed:(){
                     FirebaseFirestore.instance.collection("cbc_weekly_content").add(
                       {
                         "week":_selectedItem,
                         "startdate":_startDate,
                         "enddate":_endDate,
                         "content":widget.items
                       }
                     ).then((value){
                       Get.back();
                       Get.back();
                     });
                  },
                  child:Text("Done.")
                )
              )
            ],
          ),
        ),
      );
  }
}
