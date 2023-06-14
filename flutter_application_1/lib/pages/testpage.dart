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
  bool checkedValue1 = false;
  bool checkedValue2 = false;
  bool checkedValue3 = false;
  bool checkedValue4 = false;
  bool checkedValue5 = false;
  bool checkedValue6 = false;
  bool checkedValue7 = false;
  List<String> codes = List<String>.generate(50, (index) => '');
  String tempcode = '';
  String rec = '';
  String codesrec = '';
  var finerecommendation = '';
  var fineordrecommendation = '';

  @override
  Widget build(BuildContext context) {
    readJson();
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          pageChanged = index;
        });
      },
      itemCount: _items.length,
      itemBuilder: (context, position){
        if (position+1 == _items.length) {
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                _items[position]["text_of_sign"],
                style: const TextStyle(
                  fontSize: 20
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child:SizedBox(
                height:450,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
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
                  onPressed: () {
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    print(codes);
                    for (var i = 0; i < _recommendations.length; i++) {
                      rec = _recommendations[i]["codes"];
                      innerloop:
                      for (var code1 = 0; _items.length > code1; code1++){
                        for (var code2 = 0; _items.length > code2; code2++){
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
                      for (var code1 = 0; _items.length > code1; code1++){
                        for (var code2 = 0; _items.length > code2; code2++){
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
        if (_items[position]["n3"] == null) { //Тест с двумя ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
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
        else if (_items[position]["n4"] == null) { //Тест с тремя ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "5123",fineordinstruction: "54")),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n3"]),
                            value: checkedValue3,
                            onChanged: (value) {
                              setState(() {
                                checkedValue3 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue3){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n3";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    checkedValue3 = false;
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
        else if (_items[position]["n5"] == null) { //Тест с четыремя ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "31222",fineordinstruction: "54")),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n3"]),
                            value: checkedValue3,
                            onChanged: (value) {
                              setState(() {
                                checkedValue3 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n4"]),
                            value: checkedValue4,
                            onChanged: (value) {
                              setState(() {
                                checkedValue4 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue3){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n3";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue4){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n4";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    checkedValue3 = false;
                    checkedValue4 = false;
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
        else if (_items[position]["n6"] == null) { //Тест с пятью ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "5123",fineordinstruction: "54")),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n3"]),
                            value: checkedValue3,
                            onChanged: (value) {
                              setState(() {
                                checkedValue3 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n4"]),
                            value: checkedValue4,
                            onChanged: (value) {
                              setState(() {
                                checkedValue4 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n5"]),
                            value: checkedValue5,
                            onChanged: (value) {
                              setState(() {
                                checkedValue5 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue3){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n3";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue4){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n4";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue5){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n5";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    checkedValue3 = false;
                    checkedValue4 = false;
                    checkedValue5 = false;
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
        else if (_items[position]["n7"] == null) { //Тест с шестью ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "31222",fineordinstruction: "54")),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n3"]),
                            value: checkedValue3,
                            onChanged: (value) {
                              setState(() {
                                checkedValue3 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n4"]),
                            value: checkedValue4,
                            onChanged: (value) {
                              setState(() {
                                checkedValue4 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n5"]),
                            value: checkedValue5,
                            onChanged: (value) {
                              setState(() {
                                checkedValue5 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n6"]),
                            value: checkedValue6,
                            onChanged: (value) {
                              setState(() {
                                checkedValue6 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue3){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n3";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue4){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n4";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue5){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n5";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue6){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n6";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    checkedValue3 = false;
                    checkedValue4 = false;
                    checkedValue5 = false;
                    checkedValue6 = false;
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
        else { //Тест с семью ответами
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
                    "Вопрос " + (position + 1).toString() + " из " + _items.length.toString(),
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
                        MaterialPageRoute(builder: (context) => FirstPage(activebut: false,fineinstruction: "433434",fineordinstruction: "54")),
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
                _items[position]["text_of_sign"],
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text(_items[position]["n1"]),
                            value: checkedValue1,
                            onChanged: (value) {
                              setState(() {
                                checkedValue1 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n2"]),
                            value: checkedValue2,
                            onChanged: (value) {
                              setState(() {
                                checkedValue2 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n3"]),
                            value: checkedValue3,
                            onChanged: (value) {
                              setState(() {
                                checkedValue3 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n4"]),
                            value: checkedValue4,
                            onChanged: (value) {
                              setState(() {
                                checkedValue4 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n5"]),
                            value: checkedValue5,
                            onChanged: (value) {
                              setState(() {
                                checkedValue5 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n6"]),
                            value: checkedValue6,
                            onChanged: (value) {
                              setState(() {
                                checkedValue6 = value!;
                              });
                            },
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text(_items[position]["n7"]),
                            value: checkedValue7,
                            onChanged: (value) {
                              setState(() {
                                checkedValue7 = value!;
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
                    if (checkedValue1){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n1";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue2){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n2";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue3){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n3";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue4){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n4";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue5){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n5";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue6){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n6";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    if (checkedValue7){
                      tempcode = "s" + (position+1).toString() + "g" + _items[position]["group"] + "v" + _items[position]["vid"] + "n7";
                      codes[position] = tempcode;
                      tempcode = '';
                    }
                    checkedValue1 = false;
                    checkedValue2 = false;
                    checkedValue3 = false;
                    checkedValue4 = false;
                    checkedValue5 = false;
                    checkedValue6 = false;
                    checkedValue7 = false;
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
      }
    );
  }
}
