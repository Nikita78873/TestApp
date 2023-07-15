import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'firstpage.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
      home: Scaffold(
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
  PageController _pageController = PageController();
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

  int pageChanged = 0;
  List<String> codes = List<String>.generate(50, (index) => '');
  String tempcode = '';
  String rec = '';
  String codesrec = '';
  var finerecommendation = '';
  var fineordrecommendation = '';

  @override
  Widget build(BuildContext context) {
    readJson();
    List<Map<dynamic, dynamic>> listOfItems = [];
    List<Map<dynamic, dynamic>> _recommendations = [];
    List<Map<dynamic, dynamic>> _ordrecommendations = [];

    for (dynamic item in _items) {
      if (item is Map) {
        listOfItems.add(item);
      }
    }
    
    for (dynamic item in _recom) {
      if (item is Map) {
        _recommendations.add(item);
      }
    }

    for (dynamic item in _ordrecom) {
      if (item is Map) {
        _ordrecommendations.add(item);
      }
    }

    return PageView.builder(
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
                      _pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "123",fineordinstruction: "54")),
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
                height:350,
                child: ListView.builder(
                  itemCount: listOfItems[position]["title_answers"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(listOfItems[position]["title_answers"][index]["title"].toString()),
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
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < listOfItems[position]["title_answers"].length; i++){
                      if (answers[i]){
                        tempcode = listOfItems[position]["sign"] + listOfItems[position]["group"] + listOfItems[position]["vid"] + "n" + (i + 1).toString();
                        codes[position] = tempcode;
                        tempcode = '';
                        answers[i] = false;
                      }
                    }
                    print(codes);
                    for (var i = 0; i < _recommendations.length; i++) {
                      innerloop:
                      for (var j = 0; j < _recommendations[i]["code"].length; j++){
                        rec = json.encode(_recommendations[i]["code"][j]);
                        for (var code1 = 0; listOfItems.length > code1; code1++){
                          for (var code2 = 0; listOfItems.length > code2; code2++){
                            codesrec = codes[code1] + "+" + codes[code2];
                            if (bigzap(rec) == codes[code2]){
                              finerecommendation = finerecommendation + zap(json.encode(_recommendations[i]["data"]));
                              print(finerecommendation);
                              break innerloop;
                            }
                            if (bigzap(rec) == codesrec){
                              finerecommendation = finerecommendation + zap(json.encode(_recommendations[i]["data"]));
                              print(finerecommendation);
                              break innerloop;
                            }
                          }
                        }
                      }
                    }
                    for (var i = 0; i < _ordrecommendations.length; i++) {
                      innerloop2:
                      for (var j = 0; j < _ordrecommendations[i]["code"].length; j++){
                        rec = json.encode(_ordrecommendations[i]["code"][j]);
                        for (var code1 = 0; listOfItems.length > code1; code1++){
                          for (var code2 = 0; listOfItems.length > code2; code2++){
                            codesrec = codes[code1] + "+" + codes[code2];
                            if (bigzap(rec) == codes[code2]){
                              fineordrecommendation = fineordrecommendation + zap(json.encode(_ordrecommendations[i]["data"]));
                              print(fineordrecommendation);
                              break innerloop2;
                            }
                            if (bigzap(rec) == codesrec){
                              fineordrecommendation = fineordrecommendation + zap(json.encode(_ordrecommendations[i]["data"]));
                              print(fineordrecommendation);
                              break innerloop2;
                            }
                          }
                        }
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage(activebut: true, fineinstruction: finerecommendation, fineordinstruction: fineordrecommendation)),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(350, 70)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Закончить тестирование',
                    style: TextStyle(
                      fontSize: 24,
                    )
                  ),
                )
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
                      _pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "54",fineordinstruction: "54")),
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
                height:350,
                child: ListView.builder(
                  itemCount: listOfItems[position]["title_answers"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(listOfItems[position]["title_answers"][index]["title"].toString()),
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    _pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
                    for (int i = 0; i < listOfItems[position]["title_answers"].length; i++){
                      if (answers[i]){
                        tempcode = listOfItems[position]["sign"] + listOfItems[position]["group"] + listOfItems[position]["vid"] + "n" + (i + 1).toString();
                        codes[position] = tempcode;
                        tempcode = '';
                        answers[i] = false;
                      }
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(350, 70)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Следующий вопрос',
                    style: TextStyle(
                      fontSize: 24,
                    )
                  ),
                )
              )
            )
            ]
          )
        );
      }
    }
  );
  }
}

String zap(String str) {
  str = str.replaceAll('","', ' ');
  str = str.replaceAll('"]', ' ');
  str = str.replaceAll('["', ' ');
  return str;
}

String bigzap(String str) {
  str = str.replaceAll('"', '');
  str = str.replaceAll(',', '');
  str = str.replaceAll(' ', '');
  return str;
}