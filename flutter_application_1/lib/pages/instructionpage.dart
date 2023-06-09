import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';


class ReadJsons extends StatefulWidget {
  final String fineinstruction;
  const ReadJsons({super.key, required this.fineinstruction});
 
  @override
  State<ReadJsons> createState() => _ReadJSonsState(fineinstruction: fineinstruction);
}
 

class _ReadJSonsState extends State<ReadJsons> {
  List _items = [];
  final String fineinstruction;
  _ReadJSonsState({required this.fineinstruction});

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
    return Scaffold(
    body: Container(
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
                      MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: fineinstruction)),
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
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(fineinstruction),
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
    )
    );
  }
}