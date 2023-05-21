import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/testpage.dart';

import 'instructionpage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
          child: Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 250, 30),
                child: Text(
                  'Главная',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
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
                      MaterialPageRoute(builder: (context) => const InstructionPage()),
                    );
                  }
                )
              )
            ]
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Получить инструкции',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstructionPage()),
              );
            }
          )
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 70),
              backgroundColor: Colors.grey,
            ),
            child: const Text(
              'Ввести исходные данные',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestPage()),
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
                MaterialPageRoute(builder: (context) => const TestPage()),
              );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 40)),
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