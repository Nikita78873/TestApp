import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/changepage.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:http/http.dart' as http;
import 'instructionpage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int version = 0;
  int verscode = 0;
  String finerecommendation = '';
  String fineordrecommendation = ''; 
  bool activebut = false;
  bool _isLoading = true;
  bool information = false;

  @override
  void initState() {
    super.initState();
    checkversion();
  }

  @override
  Widget build(BuildContext context) {
    print(finerecommendation);
    return Scaffold(
      body: _isLoading
      ?
      Column(
        children : [
          SizedBox(height: 200,),
            ListTile(    
              leading: LoadingAnimationWidget.fourRotatingDots(
                color: Color.fromARGB(255, 12, 110, 42),
                size: 50,
              ),
              title: Text(
                'Происходит загрузка тестов с сервера',
                textScaleFactor: 1.5,
              ),
              subtitle: Text(
                'Если загрузка производится долго, проверьте ваше соединение'
              ),
            ),
        ]
      )
      :
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
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
                    Icons.help_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      information = !information;
                    });
                  }
                )
              )
            ]
          ),
        ),
        Container(
          child: SizedBox(
            width: 350,
            child: Visibility(
              visible: information,
              child: Text(' Эта кнопка нужна для этого, эта для этого, эта для этого, эта для этого, эта для этого')
            ),
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 1.15,
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 161, 161, 161)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
            child: const Text(
              'Ввести исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestPage()),
              );
            }
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 1.15,
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 161, 161, 161)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
            child: const Text(
              'Показать последние инструкции',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (activebut){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: convertNewLine(finerecommendation), fineordinstruction: convertNewLine(fineordrecommendation))),
                );
                print(finerecommendation);
                print(finerecommendation.indexOf(r'\n'));
              };
            }
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 1.15,
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 161, 161, 161)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
            child: const Text(
              'Изменить исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePage()),
              );
            }
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 1.15,
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(252, 161, 161, 161)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
            child: const Text(
              'Заступить на смену',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (activebut){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: convertNewLine(finerecommendation), fineordinstruction: convertNewLine(fineordrecommendation))),
                );
                print(finerecommendation);
              };
            }
          )
        ),
      ])
    );
  }
  Future _getData() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'bd.json';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    activebut = await getactivebut();
    print(activebut);

    setState(() {
      _isLoading = true;
    });

    http.get(Uri.parse('http://ests.irgups.ru/api/packet/current/getpacket')).then((response) async {
      final data = json.decode(response.body);
      int actversion = data["version"];
      int actcode = data["code"];
      if (await file.exists()) {
        if ((version != actversion) || (verscode != actcode)){
          file.create();
          file.writeAsString(response.body);
          setState(() {
            _isLoading = false;
          });
        }
        else {
          print(1);
          setState(() {
            _isLoading = false;
          });
        }
      }
      else {
        file.create();
        file.writeAsString(response.body);
        print(2);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) async {
      if (await file.exists()){
        print("Error 1");
        setState(() {
          _isLoading = false;
        });
      }
      else {
        print("Error 2");
        Future.delayed(Duration(seconds: 3), (){
          _getData();
        });
      }
    });
  }
  Future<bool> getactivebut() async {
    activebut = false;
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'rec.txt';
    const localFileName1 = 'ordrec.txt';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    final file1 = File('$locdir/$localFileName1');

    if(await file.exists()){
      activebut = true;
      finerecommendation = await file.readAsString();
      fineordrecommendation = await file1.readAsString();
    }
    return activebut;
  }
  String convertNewLine(String content) {
    print("converting");
    return content.replaceAll(r'\n', '\n');
  }
  Future<void> checkversion() async {
    final localDirectory = await getExternalStorageDirectory();
    const localFileName = 'bd.json';
    var locdir = localDirectory!.path;
    final file = File('$locdir/$localFileName');
    if (await file.exists()){
      final stroka = await file.readAsString();
      final data = await json.decode(stroka);

      setState(() {
        version = data["version"];
        verscode = data["code"];
      }
    );

    }

    _getData();
  }
}