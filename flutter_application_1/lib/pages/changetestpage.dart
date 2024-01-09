import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:http/http.dart' as http;
import 'changepage.dart';
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
  bool checker = true;
  _ChangeTestPageState({required this.codeindex});
  String stringcodes = '';
  List _items = [];
  List<bool> answers = List<bool>.generate(15, (index) => false);
  List<String> codes = List<String>.generate(50, (index) => '');
  final ScrollController controller = ScrollController();

  void gencodes() {
    String s = '';
    int tmp;
    int codedigits;
    codes = stringcodes.split(' ');
    if (checker){
    if (stringcodes == '') {
      print(s);
      rJson();
    } else {
      s = codes[codeindex];
      print(s);
      tmp = s.indexOf('n');
      print(tmp);
      if (tmp > -1) {
        for (int i = tmp; i < s.length; i++){
          if (isNumeric(s[i])){
            codedigits = int.parse(s[i]);
            if (i != s.length - 1) {
              if (isNumeric(s[i+1])){
                codedigits = int.parse('${codedigits.toString}' + '${s[i+1]}');
                i ++;
             }
            }
            print(s[i]);
            answers[codedigits - 1] = true;
            codedigits = 0;
          }
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
    gencodes();
    List<Map<dynamic, dynamic>> listOfItems = [];

    for (dynamic item in _items) {
      if (item is Map) {
        listOfItems.add(item);
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
            height: MediaQuery.of(context).size.height / 1.6,
            child: Scrollbar(
              thickness: 20.0,
              thumbVisibility: true,
              controller: controller,
            child: ListView.builder(
              controller: controller,
              itemCount: int.parse(listOfItems[codeindex]["number"]) ,
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
                            checker = false;
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
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: (){
                String tmp = "";
                tmp = listOfItems[codeindex]["sign"] + listOfItems[codeindex]["group"] + listOfItems[codeindex]["vid"];
                for (int i = 0; i < listOfItems[codeindex]["title_answers"].length; i++){
                  if (answers[i]){
                    tmp = tmp + "n" + (i + 1).toString();
                  }
                }
                codes[codeindex] = tmp;
                changecodes();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePage()),
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(350, 70)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
              child: const Text(
                'Подтвердить',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                )
              ),
            )
          )
        )
      ],
      )
    );
  }
  Future<void> rJson() async {
    const localFileName = 'bd.json';
    const localFileName1 = 'quest.txt';
    final localDirectory = await getExternalStorageDirectory();
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');
    final stroka = await file.readAsString();
    final data = await json.decode(stroka);
    final stringcode = await file1.readAsString();
    stringcodes = stringcode;
    gencodes();

    setState(() {
      _items = data["data"]["primaryQuestions"];
    });
  }
  Future<void> changecodes() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'quest.txt';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');

    file.create();
    String stringcodes = codes.join(" ");
    file.writeAsString(stringcodes);
  }
}