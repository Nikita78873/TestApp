import 'package:flutter/material.dart';

import 'dart:convert';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/instpage1.dart';
import 'package:flutter_application_1/pages/testpage.dart';


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

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

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
          margin: EdgeInsets.only(top: 10),
          child: SizedBox(
            height: 250,
            width: 400,
            child: Scrollbar(
              thickness: 20.0,
              thumbVisibility: true,
              controller: controller,
              child: ListView.builder(
                controller: controller,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Color.fromRGBO(240, 240, 240, 3),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(fineinstruction),
                        ),
                      ]
                    )
                  );
                }
              )
            )
          )
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Instpageone(fineinstruction: fineinstruction)),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(400, 30)),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(230, 230, 230, 3)),
            ),
            child: const Text(
              "нажмите, чтобы развернуть",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: SizedBox(
            height: 250,
            width: 400,
            child: Scrollbar(
              thickness: 20.0,
              thumbVisibility: true,
              controller: controller2,
              child: ListView.builder(
                controller: controller2,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Color.fromRGBO(240, 240, 240, 3),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(fineinstruction),
                        ),
                      ]
                    )
                  );
                }
              )
            )
          )
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Instpageone(fineinstruction: fineinstruction)),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(400, 30)),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(230, 230, 230, 3)),
            ),
            child: const Text(
              "нажмите, чтобы развернуть",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ]),
    )
    );
  }
}