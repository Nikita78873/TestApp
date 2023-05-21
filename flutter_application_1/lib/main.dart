import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart';
import 'package:flutter_application_1/pages/instructionpage.dart';
import 'package:flutter_application_1/pages/testpage.dart';


void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/':(context) => FirstPage(), 
    '/primary':(context) => InstructionPage(),
    '/secondary':(context) => TestPage(),

  },
),
);