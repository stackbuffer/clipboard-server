import 'package:clipboardsync/clipserver.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clipboard Server"), backgroundColor: Color(0xff33691E)),

      body: ClipServer(),
    );
  }
}