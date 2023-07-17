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
    String s;
    int tmp;
    int codedigits;
    codes = stringcodes.split(' ');
    s = codes[codeindex];
    if (s == '') {
      print(s);
      rJson();
    } else {
    print(s);
    tmp = s.indexOf('n');
    print(tmp);
    if (tmp > -1) {
      for (int i = tmp; i < s.length; i++){
        if (isNumeric(s[i])){
          codedigits = int.parse(s[i]);
          //if ((s[i+1]).isNotEmpty) {
            //if (isNumeric(s[i+1])){
              //codedigits[i - tmp] = int.parse('${codedigits[i - tmp].toString}' + '${s[i+1]}');
            //}
          //}
          print(s[i]);
          answers[codedigits - 1] = true;
          codedigits = 0;
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
      body: Column (
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text(
            listOfItems[codeindex]["title"],
            style: TextStyle(
              fontSize: 20
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
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
    );
  }
  Future<void> rJson() async {
    const localFileName = 'bd.json';
    const localFileName1 = 'quest.txt';
    final localDirectory = await getExternalStorageDirectory();
    var locdir = localDirectory!.path;
    //var locdir = '/storage/emulated/0/Android/data/com.example.flutter_application_1/files';
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');
    final stroka = await file.readAsString();
    final data = await json.decode(stroka);
    final stringcode = await file1.readAsString();
    stringcodes = stringcode;
    gencodes(stringcodes);

    setState(() {
      _items = data["data"]["primaryQuestions"];
      _recom = data["data"]["answers"]["recommendations_from_psychology"];
      _ordrecom = data["data"]["answers"]["recommendations_from_orders"];
    });
  }
}