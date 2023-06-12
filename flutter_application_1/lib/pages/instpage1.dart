import 'package:flutter/material.dart';

import 'instructionpage.dart';


class Instpageone extends StatefulWidget {
  final String fineinstruction;
  const Instpageone({super.key, required this.fineinstruction});
 
  @override
  State<Instpageone> createState() => _InstPageoneState(fineinstruction: fineinstruction);
}
 

class _InstPageoneState extends State<Instpageone> {
  final String fineinstruction;
  _InstPageoneState({required this.fineinstruction});

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