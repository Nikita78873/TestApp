import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:http/http.dart' as http;
import 'firstpage.dart';
import 'instructionpage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChangeTestPage extends StatefulWidget {
  final int codeindex;
  const ChangeTestPage({super.key, required this.codeindex});

  @override
  State<ChangeTestPage> createState() => _ChangeTestPageState(codeindex: codeindex);
}

class _ChangeTestPageState extends State<ChangeTestPage> {
  final int codeindex;
  _ChangeTestPageState({required this.codeindex});

  String stringcodes = '';
  List _items = [];
  List _recom = [];
  List _ordrecom = [];
  List<bool> answers = List<bool>.generate(15, (index) => false);
  List<String> codes = List<String>.generate(50, (index) => '');

  void gencodes(String stringcodes) {
    List<int> codedigits = List<int>.generate(50, (index) => 0);
    String s;
    int tmp;
    codes = stringcodes.split(' ');
    for (var i = 0; i < codes.length; i++){
      s = codes[i];
      tmp = s.indexOf('n');
      if (tmp > -1) {
        for (var j = tmp; j < s.length; j++){
          if (isNumeric(s[j])){
            codedigits[i] = int.parse(s[j]);
            if ((s[j+1]).isNotEmpty) {
              if (isNumeric(s[j+1])){
                codedigits[i] = codedigits[i] + int.parse(s[j]);
              }
            }
            answers[codedigits[i]] = true;
            codedigits[i] = 0;
          }
        }
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  
  @override
  Widget build(BuildContext context) {
    gencodes(stringcodes);
    rJson();
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                listOfItems[codeindex]["title"],
                style: const TextStyle(
                  fontSize: 20
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child:SizedBox(
                height:350,
                child: ListView.builder(
                  itemCount: listOfItems[codeindex]["title_answers"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(listOfItems[codeindex]["title_answers"][index]["title"].toString()),
                            value: answers[index],
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value!;
                              });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  }
                )
              )
            ),
          ],
        )
      )
    );
  }
  Future<void> rJson() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'bd.json';
    const localFileName1 = 'quest.txt';
    var locdir = localDirectory!.path; 
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');
    final stroka = await file.readAsString();
    final data = await json.decode(stroka);
    final stringcode = await file1.readAsString();
    stringcodes = stringcode;

    setState(() {
      _items = data["data"]["primaryQuestions"];
      _recom = data["data"]["answers"]["recommendations_from_psychology"];
      _ordrecom = data["data"]["answers"]["recommendations_from_orders"];
    });
  }
}