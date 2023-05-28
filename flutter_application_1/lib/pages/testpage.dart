import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';

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
 
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/bd.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["encoding_attribute"];
    });
  }
 
  int pageChanged = 0;
  bool checkedValue1 = false;
  bool checkedValue2 = false;

  @override
  Widget build(BuildContext context) {
    readJson();
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          pageChanged = index;
        });
      },
      itemCount: _items.length,
      itemBuilder: (context, position){
        return Column(
          children: [
            Row(
              children:[
                ElevatedButton(
                  child: Text('Back'),
                  onPressed: (){
                    _pageController.animateToPage(--pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                  }
                ),
                Text("Вопрос " + (position + 1).toString())
              ]
            ),
            SizedBox(
              height:200,
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
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  child: Text("Next question"),
                  onPressed: (){
                    _pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                  }
                )
              )
            )
          ]
        );
      }
    );
  }
}