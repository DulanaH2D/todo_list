

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  
  //-----------------Form Key, Email, Password -----------------//
  final formkey = GlobalKey<FormState>();
  var email = '';
  var password = '';
  var username = '';
  bool isLoginPage = false;

  //-----------------Authentication functions -----------------//
  startAuthentication(){
    final validity = formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity){
      formkey.currentState!.save();
      submitForm(email, password, username);
    }
  }

  submitForm(String email, String password, String username)async{
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try{
      if(isLoginPage){
        userCredential = await auth.signInWithEmailAndPassword(email: email, password: password); 
    }else{
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        //'password': password,
      });
    }
  }catch(err){
    print(err);
  }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Form
          (
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                

                 //--------------Username----------------//
                if(!isLoginPage)
               
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('username'),
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
                onSaved: (value){
                  username = value!;
                },
                
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide()
                  ),
                  labelText: "Enter username",
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),

                SizedBox(height: 10),

              //--------------Email----------------//
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('email'),
                validator: (value) {
                  if(value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value){
                  email = value!;
                },
                
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide()
                  ),
                  labelText: "Enter Email",
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),

              SizedBox(height: 10),

              //--------------Password----------------//
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('password'),
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Incorrect password';
                  }
                  return null;
                },
                onSaved: (value){
                  password = value!;
                },
                
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                    borderSide: BorderSide()
                  ),
                  labelText: "Enter password",
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              
              SizedBox(height: 10,),
              
              //--------------Login / Sign Up Button----------------//
              Container(child: ElevatedButton(onPressed: () {startAuthentication();},child: isLoginPage? Text('Login'):Text('Sign Up'),)),
              
              SizedBox(height: 10,),
              
              //--------------Switch between Login and Sign Up----------------//
              Container(child: TextButton(onPressed: () {
                setState(() {
                  isLoginPage = !isLoginPage;
                });
              }, child: isLoginPage? Text('Not a Member'):Text('Already a Member'),),),

            ],)),
        )
      ],),
    );
  }
}