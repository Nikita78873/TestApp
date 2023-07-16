import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:http/http.dart' as http;
import 'firstpage.dart';
import 'instructionpage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChangePage extends StatefulWidget {
  const ChangePage({Key? key}) : super(key: key);

  @override
  State<ChangePage> createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> {
  List _items = [];
  List _recom = [];
  List _ordrecom = [];
  List<bool> answers = List<bool>.generate(15, (index) => false);

  Future<void> readJson() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'bd.json';
    var locdir = localDirectory!.path; 
    final file = File('$locdir/$localFileName');
    final stroka = await file.readAsString();
    final data = await json.decode(stroka);

    setState(() {
      _items = data["data"]["primaryQuestions"];
      _recom = data["data"]["answers"]["recommendations_from_psychology"];
      _ordrecom = data["data"]["answers"]["recommendations_from_orders"];
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    List<Map<dynamic, dynamic>> listOfItems = [];
    List<Map<dynamic, dynamic>> recommendations = [];
    List<Map<dynamic, dynamic>> ordrecommendations = [];

    for (dynamic item in _items) {
      if (item is Map) {
        listOfItems.add(item);
      }
    }
    
    for (dynamic item in _recom) {
      if (item is Map) {
        recommendations.add(item);
      }
    }

    for (dynamic item in _ordrecom) {
      if (item is Map) {
        ordrecommendations.add(item);
      }
    }
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                  child: const Icon(
                    color: Colors.black,
                    Icons.close
                  )
                ),
              ]
            ),
            Container(
              child:SizedBox(
                height:520,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text((index+1).toString() + " " + listOfItems[index]["title"]),
                          ),
                        Divider()
                        ]
                      ),
                    );
                  }
                )
              )
            )
          ],
        )
      )
    );
  }
}