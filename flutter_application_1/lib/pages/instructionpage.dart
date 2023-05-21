import 'package:flutter/material.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key}) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'hello'
      ),
    );
  }
}