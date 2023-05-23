import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Read Json Data';
 
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: ReadJson(),
      ),
    );
  }
}
class ReadJson extends StatefulWidget {
  const ReadJson({Key? key}) : super(key: key);
 
  @override
  _ReadJsonState createState() => _ReadJsonState();
}
 
class _ReadJsonState extends State<ReadJson> {
  List _items = [];
 
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('bd.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["encoding_attribute"];
    });
  }
 
  @override
  Widget build(BuildContext context) {
    readJson();
    return Container(
      child:
      ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sign is : ' + _items[index]["sign"]),
                    subtitle: Text('Number is : ' + _items[index]["number"] ),
                  ),
                  Divider(),
                ],
              ),
 
            );
          }
 
      ),
 
    );
  }
}