import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/changetestpage.dart';
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
  bool information = false;
  List<bool> answers = List<bool>.generate(15, (index) => false);
  List<String> codes = List<String>.generate(50, (index) => '');
  final ScrollController controller = ScrollController();

  Future<void> readJson() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'bd.json';
    const localFileName1 = 'quest.txt';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');
    final stroka = await file.readAsString();
    final stringcode = await file1.readAsString();
    final data = await json.decode(stroka);
    codes = stringcode.split(' ');

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
                  style: TextButton.styleFrom(
                    minimumSize: const Size(20, 40),
                  ),
                  child: const Icon(
                    Icons.help_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      information = !information;
                    });
                  }
                ),
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
            Column(
              children: [ 
                SizedBox(
                  width: 350,
                  child: Visibility(
                    visible: information,
                    child: Text(' Эта кнопка нужна для этого, эта для этого, эта для этого, эта для этого, эта для этого')
                  ),
                ),
                SizedBox(
                height:470,
                child: Scrollbar(
                  thickness: 20.0,
                  thumbVisibility: true,
                  controller: controller,
                  child: ListView.builder(
                  controller: controller,
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text((index+1).toString() + " " + listOfItems[index]["title"]),
                            subtitle: Text((listOfItems[index]["title_answers"][0]["title"]).toString() + "\n" + (listOfItems[index]["title_answers"][1]["title"]).toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangeTestPage(codeindex: index)),
                              );
                            }
                          ),
                        Divider()
                        ]
                      ),
                    );
                  }
                )
                )
              )
          ]),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    String rec, codesrec, finerecommendation = '', fineordrecommendation = '';
                    for (var i = 0; i < recommendations.length; i++) {
                      innerloop:
                      for (var j = 0; j < recommendations[i]["code"].length; j++){
                        rec = json.encode(recommendations[i]["code"][j]);
                        for (var code1 = 0; listOfItems.length > code1; code1++){
                          for (var code2 = 0; listOfItems.length > code2; code2++){
                            codesrec = codes[code1] + "+" + codes[code2];
                            if (bigzap(rec) == codes[code2]){
                              finerecommendation = finerecommendation + zap(json.encode(recommendations[i]["data"]));
                              print(finerecommendation);
                              break innerloop;
                            }
                            if (bigzap(rec) == codesrec){
                              finerecommendation = finerecommendation + zap(json.encode(recommendations[i]["data"]));
                              print(finerecommendation);
                              break innerloop;
                            }
                          }
                        }
                      }
                    }
                    for (var i = 0; i < ordrecommendations.length; i++) {
                      innerloop2:
                      for (var j = 0; j < ordrecommendations[i]["code"].length; j++){
                        rec = json.encode(ordrecommendations[i]["code"][j]);
                        for (var code1 = 0; listOfItems.length > code1; code1++){
                          for (var code2 = 0; listOfItems.length > code2; code2++){
                            codesrec = codes[code1] + "+" + codes[code2];
                            if (bigzap(rec) == codes[code2]){
                              fineordrecommendation = fineordrecommendation + zap(json.encode(ordrecommendations[i]["data"]));
                              print(fineordrecommendation);
                              break innerloop2;
                            }
                            if (bigzap(rec) == codesrec){
                              fineordrecommendation = fineordrecommendation + zap(json.encode(ordrecommendations[i]["data"]));
                              print(fineordrecommendation);
                              break innerloop2;
                            }
                          }
                        }
                      }
                    }
                    printrecs(finerecommendation, fineordrecommendation);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(350, 70)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(
                      fontSize: 24,
                    )
                  ),
                )
              )
            )
          ],
        )
      )
    );
  }
  
  Future<void> printrecs(String fine, String fineord) async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'rec.txt';
    const localFileName1 = 'ordrec.txt';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');

    file.create();
    file.writeAsString(fine);
    file1.create();
    file1.writeAsString(fineord);
  }
}