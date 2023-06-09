import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart';
import 'package:flutter_application_1/pages/instructionpage.dart';
import 'package:flutter_application_1/pages/testpage.dart';


void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/':(context) => FirstPage(activebut: false, fineinstruction: "322"), 
    '/primary':(context) => ReadJsons(fineinstruction: ""),
    '/secondary':(context) => TestPage(),
  },
),
);