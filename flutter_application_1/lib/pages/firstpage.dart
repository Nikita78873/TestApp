import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:http/http.dart' as http;
import 'instructionpage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FirstPage extends StatefulWidget {
  final bool activebut;
  final String fineinstruction;
  final String fineordinstruction;
  const FirstPage({super.key, required this.activebut, required this.fineinstruction, required this.fineordinstruction});

  @override
  State<FirstPage> createState() => _FirstPageState(activebut: activebut, fineinstruction: fineinstruction, fineordinstruction: fineordinstruction);
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    //_getData();
  }

  final bool activebut;
  final String fineinstruction;
  final String fineordinstruction;

  _FirstPageState({required this.activebut, required this.fineinstruction, required this.fineordinstruction});
  
  showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'OK'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Ошибка!"),
    content: Text("Сначала пройдите тестирование"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    if (activebut){
    return Scaffold(
      body: Column(children: <Widget>[
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  'Главная',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:20, right:20, top:15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Получить инструкции',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction)),
              );
            }
          )
        ),
        Container(
          margin: EdgeInsets.only(left:20, right:20, top:25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Ввести исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
            }
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(350, 40)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text(
                'Заступить на смену',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ]),
    );
    }
    else {
      return Scaffold(
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 9,
                child: Text(
                  'Главная',
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
                      MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: "32",fineordinstruction: "54")),
                    );
                  }
                )
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:20, right:20, top:15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Получить инструкции',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              showAlertDialog(context);
            }
          )
        ),
        Container(
          margin: EdgeInsets.only(left:20, right:20, top:25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Ввести исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
            }
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(350, 40)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text(
                'Заступить на смену',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ]),
    );
    }
  }

  /*
  _getData () {
    Directory directory = getApplicationDocumentsDirectory();
    final url = Uri.parse('http://a0822582.xsph.ru/api/packet/current/packet');
    final File file = File("/assets/example.json");

    String _body = '';

    http.get(url).then((response){
      //file.writeAsStringSync(response.body);
      _body = response.body;
      file.writeAsStringSync('dsfghg');
    }).catchError((error){
      print("Error: $error");
    });
  }
  */ 
}