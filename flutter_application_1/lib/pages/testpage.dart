import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';

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
  List _recommendations = [];
  List _ordrecommendations = [];
  List<bool> answers = List<bool>.generate(15, (index) => false);

  Future<void> readJson() async {
    final String response2 = await rootBundle.loadString('assets/order_recommendations.json');
    final String response1 = await rootBundle.loadString('assets/psycho_recommendations.json');
    final String response = await rootBundle.loadString('assets/bd.json');
    final data2 = await json.decode(response2);
    final data1 = await json.decode(response1);
    final data = await json.decode(response);
    setState(() {
      _items = data["encoding_attribute"];
      _recommendations = data1["recommendations_from_psychology"];
      _ordrecommendations = data2["recommendations_from_orders"];
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

    for (dynamic item in _items) {
      if (item is Map) {
        listOfItems.add(item);
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
                      rec = _recommendations[i]["codes"];
                      innerloop:
                      for (var code1 = 0; listOfItems.length > code1; code1++){
                        for (var code2 = 0; listOfItems.length > code2; code2++){
                          codesrec = codes[code1] + "+" + codes[code2];
                          if (rec.contains(codesrec)){
                            finerecommendation = finerecommendation + _recommendations[i]["recommendation"];
                            print(finerecommendation);
                            break innerloop;
                          }
                        }
                      }
                    }
                    for (var i = 0; i < _ordrecommendations.length; i++) {
                      rec = _ordrecommendations[i]["codes"];
                      innerloop2:
                      for (var code1 = 0; listOfItems.length > code1; code1++){
                        for (var code2 = 0; listOfItems.length > code2; code2++){
                          codesrec = codes[code1] + "+" + codes[code2];
                          if (rec.contains(codesrec)){
                            fineordrecommendation = fineordrecommendation + _ordrecommendations[i]["recommendation"];
                            print(fineordrecommendation);
                            break innerloop2;
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