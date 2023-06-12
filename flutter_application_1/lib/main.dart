import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart';
import 'package:flutter_application_1/pages/instpage1.dart';
import 'package:flutter_application_1/pages/instpage2.dart';
import 'package:flutter_application_1/pages/instructionpage.dart';
import 'package:flutter_application_1/pages/testpage.dart';


void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/':(context) => FirstPage(activebut: false, fineinstruction: "322", fineordinstruction: "322"), 
    '/primary':(context) => ReadJsons(fineinstruction: "", fineordinstruction: "54"),
    '/secondary':(context) => TestPage(),
    '/instructionsopened':(context) => Instpageone(fineinstruction: "222", fineordinstruction: "54"),
    '/instructionsopened2':(context) => Instpagetwo(fineinstruction: "322", fineordinstruction: "54"),
  },
),
);