import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/instpage1.dart';
import 'package:flutter_application_1/pages/instpage2.dart';
import 'package:path_provider/path_provider.dart';


class ReadJsons extends StatefulWidget {
  final String fineinstruction;
  final String fineordinstruction;
  const ReadJsons({super.key, required this.fineinstruction, required this.fineordinstruction});

  @override
  State<ReadJsons> createState() => _ReadJSonsState(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction);
}
 

class _ReadJSonsState extends State<ReadJsons> {
  final String fineinstruction;
  final String fineordinstruction;
  _ReadJSonsState({required this.fineinstruction, required this.fineordinstruction});

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
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
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  }
                )
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1.05,
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
          height: MediaQuery.of(context).size.height / 20,
          width: MediaQuery.of(context).size.width / 1.05,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Instpageone(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction)),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(400, 30)),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(230, 230, 230, 3)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)))
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
          margin: EdgeInsets.all(5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1.05,
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
                          title: Text(fineordinstruction),
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
          height: MediaQuery.of(context).size.height / 20,
          width: MediaQuery.of(context).size.width / 1.05,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Instpagetwo(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction)),
              );
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(400, 30)),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(230, 230, 230, 3)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
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