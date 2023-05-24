import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';

class InstructionPage extends StatelessWidget {
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
  _ReadJSonState createState() => _ReadJSonState();
}
 

class _ReadJSonState extends State<ReadJson> {
  List _items = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/bd.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["encoding_attribute"];
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Container(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 9,
                child: Text(
                  'Решение',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(20, 40),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    size: 24,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InstructionPage()),
                    );
                  }
                )
              )
            ]
          ),
        ),
        Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
            height: 250,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(_items[index]["sign"]),
                          title: Text(_items[index]["number"]),
                          subtitle: Text(_items[index]["n1"]),
                        ),
                        Divider(),
                      ]
                    )
                  );
                }
              ),
            )
        ),
        Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
            height: 250,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(_items[index]["sign"]),
                          title: Text(_items[index]["number"]),
                          subtitle: Text(_items[index]["n1"]),
                        ),
                        Divider(),
                      ]
                    )
                  );
                }
              ),
            )
        ),
      ]),
    );
  }
}