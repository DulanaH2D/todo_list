import 'package:flutter/material.dart';
import 'package:todo_list/screens/home.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: const Color.fromARGB(255, 181, 12, 211)),
    );
  }
} 