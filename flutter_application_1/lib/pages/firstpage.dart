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
  String finerecommendation = '';
  String fineordrecommendation = ''; 
  bool activebut = false;
  bool _isLoading = true;
  bool information = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
      ?
      Column(
        children : [
          SizedBox(height: 200,),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: LoadingAnimationWidget.fourRotatingDots(
                color: Color.fromARGB(255, 12, 110, 42),
                size: 50,
              ),
              title: Text(
                'Происходит загрузка тестов с сервера',
                textScaleFactor: 1.5,
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
        Container(
          margin: EdgeInsets.only(left:20, right:20, top:25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Показать последние инструкции',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              if (activebut){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: finerecommendation, fineordinstruction: fineordrecommendation,)),
                );
                print(finerecommendation);
              };
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
              'Изменить исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
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
          margin: EdgeInsets.only(left:20, right:20, top:25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Заступить на смену',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            onPressed: () {
              if (activebut){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: finerecommendation, fineordinstruction: fineordrecommendation,)),
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
      _isLoading = true; // your loader has started to load
    });

    http.get(Uri.parse('http://a0839049.xsph.ru/api/packet/current/getpacket')).then((response){
      file.create();
      file.writeAsString(response.body);
      print(response.body);
      print(file);
    }).catchError((error){
      print("Error");
    });

    setState(() {
      _isLoading = false; 
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
}