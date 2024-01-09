import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/firstpage.dart';

class Titul extends StatelessWidget {
  const Titul({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/title_back.png"),
                  fit: BoxFit.none,
                  repeat: ImageRepeat.repeat),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Справочно-экспертная система поведения работников ПТБ при возникновении экстремальных и нештатных ситуаций',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            //height: MediaQuery.of(context).size.height / 10,
            //width: MediaQuery.of(context).size.width / 1.15,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(252, 161, 161, 161)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: const Text(
                'Приступить к работе',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
