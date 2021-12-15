import 'package:flutter/material.dart';

import '../widgets/location_input.dart';
import '../widgets/image_input.dart';

class AddReportScreen extends StatefulWidget {
  static const routeName = '/add-report';
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  List<String> _categories = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  String dropdownValue = 'Wybierz kategorię';
  RelativeRect position;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Widget _categorySelectorBuilder() {
    return Container(
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(dropdownValue),
        )),
        PopupMenuButton(
            onSelected: (value) => {
                  setState(() {
                    dropdownValue = value;
                  })
                },
            icon: Icon(Icons.arrow_drop_down),
            itemBuilder: (ctx) {
              return _categories
                  .map((category) =>
                      PopupMenuItem(value: category, child: Text(category)))
                  .toList();
            })
      ]),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tworzenie zgłoszenia'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  // color: Colors.amber,
                  child: Text(
                    'Utwórz zgłoszenie',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _categorySelectorBuilder(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  child: TextField(
                    maxLength: 100,
                    maxLines: 1,
                    controller: _titleController,
                    decoration: InputDecoration(
                        label: Text('Tytuł'), border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 500,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      label: Text('Opis'), border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                ImageInput(),
                SizedBox(
                  height: 10,
                ),
                LocationInput()
              ],
            ),
          ),
        ));
  }
}
