import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart'; //подключаем класс FirstPage
import 'package:flutter_application_1/pages/instructionpage.dart';//подключаем класс InstructionPage
import 'package:flutter_application_1/pages/testpage.dart';//подключаем класс TestPage


void main() => runApp(MaterialApp(

  initialRoute: '/', //начальная страница
  routes: {
    '/':(context) => FirstPage(), //главная страница
    '/primary':(context) => InstructionPage(),
    '/secondary':(context) => TestPage(),

  },
),
);