import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {

  const Page1({super.key});

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
                      MaterialPageRoute(builder: (context) => const Page2()),
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
                MaterialPageRoute(builder: (context) => const Page3()),
              );
            }
          )
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 21, 0, 0),
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
                MaterialPageRoute(builder: (context) => const Page3()),
              );
            }
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Пустая страница'),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Пустая страница'),
      ),
    );
  }
}