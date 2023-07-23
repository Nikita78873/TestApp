import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'instructionpage.dart';


class Instpagetwo extends StatefulWidget {
  final String fineinstruction;
  final String fineordinstruction;
  const Instpagetwo({super.key, required this.fineordinstruction, required this.fineinstruction});
 
  @override
  State<Instpagetwo> createState() => _InstPagetwoState(fineordinstruction: fineordinstruction, fineinstruction: fineinstruction);
}
 

class _InstPagetwoState extends State<Instpagetwo> {
  final String fineinstruction;
  final String fineordinstruction;
  _InstPagetwoState({required this.fineordinstruction, required this.fineinstruction});
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Container( 
          margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ 
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: fineinstruction,fineordinstruction: fineordinstruction)),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(50, 50)),
                    ),
                    child: const Icon(
                      color: Colors.black,
                      Icons.close
                    )
                  )
                ]
              ),
              Text(
                fineordinstruction
              )
            ]
          )
        )
      )
    );
  }
}