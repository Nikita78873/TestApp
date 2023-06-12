import 'package:flutter/material.dart';

import 'instructionpage.dart';


class Instpagetwo extends StatefulWidget {
  final String fineinstruction;
  const Instpagetwo({super.key, required this.fineinstruction});
 
  @override
  State<Instpagetwo> createState() => _InstPagetwoState(fineinstruction: fineinstruction);
}
 

class _InstPagetwoState extends State<Instpagetwo> {
  final String fineinstruction;
  _InstPagetwoState({required this.fineinstruction});

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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadJsons(fineinstruction: fineinstruction)),
                      );
                    },
                    child: const Icon(
                      Icons.settings_rounded,
                      size: 24,
                      color: Colors.black,
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