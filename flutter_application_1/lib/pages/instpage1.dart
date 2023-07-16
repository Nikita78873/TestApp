import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'instructionpage.dart';


class Instpageone extends StatefulWidget {
  final String fineinstruction;
  final String fineordinstruction;
  const Instpageone({super.key, required this.fineinstruction, required this.fineordinstruction});
 
  @override
  State<Instpageone> createState() => _InstPageoneState(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction);
}
 

class _InstPageoneState extends State<Instpageone> {
  final String fineinstruction;
  final String fineordinstruction;
  _InstPageoneState({required this.fineinstruction, required this.fineordinstruction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: fineinstruction, fineordinstruction: fineordinstruction,)),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(50, 50)),
                    ),
                    child: const Icon(
                      color: Colors.black,
                      Icons.close
                    ),
                  )
                ]
              ),
              Text(
                fineinstruction
              )
            ]
          )
        )
      )
    );
  }
}