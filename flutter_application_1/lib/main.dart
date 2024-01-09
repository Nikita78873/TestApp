import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/changepage.dart';
import 'package:flutter_application_1/pages/changetestpage.dart';
import 'package:flutter_application_1/pages/firstpage.dart';
import 'package:flutter_application_1/pages/instpage1.dart';
import 'package:flutter_application_1/pages/instpage2.dart';
import 'package:flutter_application_1/pages/instructionpage.dart';
import 'package:flutter_application_1/pages/testpage.dart';
import 'package:flutter_application_1/pages/titul.dart';


void main() => runApp(MaterialApp(

  initialRoute: 'titul',
  routes: {
    '/':(context) => FirstPage(),
    'titul':(context) => Titul(),
    '/primary':(context) => ReadJsons(fineinstruction: '',fineordinstruction: ''),
    '/secondary':(context) => TestPage(),
    '/instructionsopened':(context) => Instpageone(fineinstruction: '', fineordinstruction: ''),
    '/instructionsopened2':(context) => Instpagetwo(fineinstruction: '', fineordinstruction: ''),
    '/change':(context) => ChangePage(),
    '/changetest':(context) => ChangeTestPage(codeindex: 0)
  },
),
);