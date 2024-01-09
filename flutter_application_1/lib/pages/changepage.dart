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
  String stringcodes = '';
  String finerecommendation = '', fineordrecommendation = '';
  List<List<bool>> answers = List.generate(40, (index) => List<bool>.generate(7, (index) => false));
  List<String> codes = List<String>.generate(50, (index) => '');
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    readJson();
  }

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
    gencodes();
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
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: Visibility(
                    visible: information,
                    child: Text(' Эта кнопка нужна для этого, эта для этого, эта для этого, эта для этого, эта для этого', textAlign: TextAlign.center,)
                  ),
                ),
                SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Scrollbar(
                  thickness: 20.0,
                  thumbVisibility: true,
                  controller: controller,
                  child: ListView.builder(
                  controller: controller,
                  itemCount: listOfItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                            ListTile(
                              title: Text((index+1).toString() + " " + listOfItems[index]["title"],),
                              subtitle: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: int.parse(listOfItems[index]["number"]) ,
                                itemBuilder: (BuildContext context, int index1) {
                                  return CheckboxListTile(
                                    title: Text(
                                      ("\n" + listOfItems[index]["title_answers"][index1]["title"]).toString(),
                                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                                    ),
                                    value: answers[index][index1], 
                                    onChanged: (value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChangeTestPage(codeindex: index)),
                                      );
                                    }, 
                                  );
                                },
                              ),
                            ),
                            Divider()
                      ]
                    );
                  }
                )
              )
            )
            ]
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    for (var i = 0; i < recommendations.length; i++) {
                      outerloop:
                      for (var j = 0; j < recommendations[i]["code"].length; j++){
                        List<String> rec = bigzap(json.encode(recommendations[i]["code"][j])).split('+');
                        int counter = 0;
                        for (var k = 0; k < codes.length; k++){
                          if (codecontains(rec, codes[k])) {
                            counter++;
                          }
                        }
                        if (counter == rec.length) {
                          finerecommendation = finerecommendation + zap(json.encode(recommendations[i]["data"]));
                          break outerloop;
                        }
                      }
                    }

                    for (var i = 0; i < ordrecommendations.length; i++) {
                      outerloop1:
                      for (var j = 0; j < ordrecommendations[i]["code"].length; j++){
                        List<String> rec = bigzap(json.encode(ordrecommendations[i]["code"][j])).split('+');
                        int counter = 0;
                        for (var k = 0; k < codes.length; k++){
                          if (codecontains(rec, codes[k])) {
                            counter++;
                          } 
                        }
                        if (counter == rec.length) {
                          fineordrecommendation = fineordrecommendation + zap(json.encode(ordrecommendations[i]["data"]));
                          break outerloop1;
                        }
                      }
                    }

                    // for (var i = 0; i < recommendations.length; i++) {
                    //   innerloop:
                    //   for (var j = 0; j < recommendations[i]["code"].length; j++){
                    //     rec = json.encode(recommendations[i]["code"][j]);
                    //     for (var code1 = 0; listOfItems.length > code1; code1++){
                    //       for (var code2 = 0; listOfItems.length > code2; code2++){
                    //         codesrec = codes[code1] + "+" + codes[code2];
                    //         if (bigzap(rec) == codes[code2]){
                    //           finerecommendation = finerecommendation + zap(json.encode(recommendations[i]["data"]));
                    //           print(finerecommendation);
                    //           break innerloop;
                    //         }
                    //         if (bigzap(rec) == codesrec){
                    //           finerecommendation = finerecommendation + zap(json.encode(recommendations[i]["data"]));
                    //           print(finerecommendation);
                    //           break innerloop;
                    //         }
                    //       }
                    //     }
                    //   }
                    // }
                    // for (var i = 0; i < ordrecommendations.length; i++) {
                    //   innerloop2:
                    //   for (var j = 0; j < ordrecommendations[i]["code"].length; j++){
                    //     rec = json.encode(ordrecommendations[i]["code"][j]);
                    //     for (var code1 = 0; listOfItems.length > code1; code1++){
                    //       for (var code2 = 0; listOfItems.length > code2; code2++){
                    //         codesrec = codes[code1] + "+" + codes[code2];
                    //         if (bigzap(rec) == codes[code2]){
                    //           fineordrecommendation = fineordrecommendation + zap(json.encode(ordrecommendations[i]["data"]));
                    //           print(fineordrecommendation);
                    //           break innerloop2;
                    //         }
                    //         if (bigzap(rec) == codesrec){
                    //           fineordrecommendation = fineordrecommendation + zap(json.encode(ordrecommendations[i]["data"]));
                    //           print(fineordrecommendation);
                    //           break innerloop2;
                    //         }
                    //       }
                    //     }
                    //   }
                    // }
                    if (finerecommendation == '' && fineordrecommendation == ''){
                      printrecs("Психологические рекомендации не сформированы, попробуйте пройти тест снова", "Правовые рекомендации не сформированы, попробуйте пройти тест снова");
                    }
                    else if (finerecommendation == ''){
                      printrecs("Психологические рекомендации не сформированы, попробуйте пройти тест снова", fineordrecommendation);
                    }
                    else if (fineordrecommendation == ''){
                      printrecs(finerecommendation, "Правовые рекомендации не сформированы, попробуйте пройти тест снова");
                    }
                    else {
                      printrecs(finerecommendation, fineordrecommendation);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 11)),
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
  
  void gencodes() {
    String s = '';
    int tmp;
    int codedigits;
    codes;
      for (int ind = 0; ind < codes.length; ind++) {
        s = codes[ind];
        tmp = s.indexOf('n');
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
              answers[ind][codedigits - 1] = true;
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
}