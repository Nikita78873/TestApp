import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'firstpage.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
 
  @override
  _TestPageState createState() => _TestPageState();
}
 
class _TestPageState extends State<TestPage> {
  PageController _pageController = PageController();
  List _items = [];
  List _recom = [];
  List _ordrecom = [];
  List<List<bool>> answers = List.generate(40, (index) => List<bool>.generate(7, (index) => false));
  final ScrollController controller = ScrollController();

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

  int pageChanged = 0;
  List<String> codes = List<String>.generate(50, (index) => '');
  String codesrec = '';
  var finerecommendation = '';
  var fineordrecommendation = '';

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
      body:
    PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          pageChanged = index;
        });
      },
      itemCount: listOfItems.length,
      itemBuilder: (context, position){
        if (position+1 == listOfItems.length) {
          return Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(
                  flex: 1,
                  child: TextButton(
                    child: const Icon(
                      color: Colors.black,
                      Icons.arrow_back
                    ),
                    onPressed: (){
                      if (position > 0) {
                        _pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
                      }
                    }
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    "Вопрос " + (position + 1).toString() + " из " + listOfItems.length.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
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
                  )
                )
              ]
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                listOfItems[position]["title"],
                style: const TextStyle(
                  fontSize: 20
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child:SizedBox(
                height:MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemCount: int.parse(listOfItems[position]["number"]),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(listOfItems[position]["title_answers"][index]["title"].toString()),
                            value: answers[position][index],
                            onChanged: (value) {
                              setState(() {
                                answers[position][index] = value!;
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
            Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    String tmp = "";
                    tmp = listOfItems[position]["sign"] + listOfItems[position]["group"] + listOfItems[position]["vid"];
                    for (int i = 0; i < int.parse(listOfItems[position]["number"]); i++){
                      if (answers[position][i]){
                        tmp = tmp + "n" + (i + 1).toString();
                      }
                    }
                    codes[position] = tmp;
                    print(codes);
                    print(3);

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
                      prints("Психологические рекомендации не сформированы, попробуйте пройти тест снова", "Правовые рекомендации не сформированы, попробуйте пройти тест снова", codes);
                    }
                    else if (finerecommendation == ''){
                      prints("Психологические рекомендации не сформированы, попробуйте пройти тест снова", fineordrecommendation, codes);
                    }
                    else if (fineordrecommendation == ''){
                      prints(finerecommendation, "Правовые рекомендации не сформированы, попробуйте пройти тест снова", codes);
                    }
                    else {
                      prints(finerecommendation, fineordrecommendation, codes);
                    }
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.05, MediaQuery.of(context).size.height / 12,)),
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 0, 0, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  child: const Text(
                    'Закончить тестирование',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    )
                  ),
                )
              )
            ]
          )
        );
        } else {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(
                  flex: 1,
                  child: TextButton(
                    child: const Icon(
                      color: Colors.black,
                      Icons.arrow_back
                    ),
                    onPressed: (){
                      if (position > 0) {
                        _pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
                      }
                    }
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    "Вопрос " + (position + 1).toString() + " из " + listOfItems.length.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
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
                  )
                )
              ]
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                listOfItems[position]["title"],
                style: const TextStyle(
                  fontSize: 20
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child:SizedBox(
                height:MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  controller: controller,
                  itemCount: int.parse(listOfItems[position]["number"]),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(listOfItems[position]["title_answers"][index]["title"].toString()),
                            value: answers[position][index],
                            onChanged: (value) {
                              setState(() {
                                answers[position][index] = value!;
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
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    _pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
                    String tmp = "";
                    tmp = listOfItems[position]["sign"] + listOfItems[position]["group"] + listOfItems[position]["vid"];
                    for (int i = 0; i < int.parse(listOfItems[position]["number"]) ; i++){
                      if (answers[position][i]){
                        tmp = tmp + "n" + (i + 1).toString();
                      }
                    }
                    codes[position] = tmp;
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.05, MediaQuery.of(context).size.height / 12,)),
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 0, 0, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                  child: const Text(
                    'Следующий вопрос',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    )
                  ),
                )
              )
            ]
          )
        );
      }
    }
  )
    );
  }
}

Future<void> prints(String fine, String fineord, List<String> codes) async{
  final localDirectory = await getExternalStorageDirectory();
  const localFileName = 'rec.txt';
  const localFileName1 = 'ordrec.txt';
  const localFileName2 = 'quest.txt';
  var locdir = localDirectory!.path;
  final file = File('$locdir/$localFileName');
  final file1 = File('$locdir/$localFileName1');
  final file2 = File('$locdir/$localFileName2');

  file.create();
  file.writeAsString(fine);
  file1.create();
  file1.writeAsString(fineord);
  file2.create();
  String stringcodes = codes.join(" ");
  file2.writeAsString(stringcodes);
}

String zap(String str) {
  str = str.replaceAll('","', ' ');
  str = str.replaceAll('"]', '');
  str = str.replaceAll('["', '');
  return str;
}

String bigzap(String str) {
  str = str.replaceAll('"', '');
  str = str.replaceAll(',', '');
  str = str.replaceAll(' ', '');
  return str;
}

bool codecontains(List<String> codes, String code){
  for (int i = 0; i < codes.length; i++){
    if (codes[i] == code){
      return true;
    }
  }
  return false;
}