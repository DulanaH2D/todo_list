import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth/authscreen.dart';
import 'package:todo_list/screens/home.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged, builder: (context, usersnapshot){
        if(usersnapshot.hasData){
          return Home();
        }else{
          return AuthScreen();
        }
      }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: const Color.fromARGB(255, 181, 12, 211)),
    );
  }
} 