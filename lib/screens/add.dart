import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  

  addtaskoffirebase() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    
    var time = DateTime.now();
    await FirebaseFirestore.instance
      .collection('tasks')
      .doc(uid)
      .collection('mytasks')
      .doc(time.toString())
      .set({
      'name': nameController.text,
      'description': descriptionController.text,
      'time': time.toString(),
    });
    Fluttertoast.showToast(msg: 'Data Added Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task")
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [            
            Container(child: TextField(
              controller: nameController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Task Name"),
            ),),
            SizedBox(height: 10,),
            Container(child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Description"),
            ),),
            SizedBox(height: 10,),
            Container(
              width:double.infinity,
              height:50,
              child:ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if(states.contains(MaterialState.pressed))
                    return Colors.purple.shade100;
                  return Theme.of(context).primaryColor;
                })),
                onPressed: (){
                  addtaskoffirebase();
                }, child: Text("Add Task", style: GoogleFonts.roboto(fontSize: 18),),))
          ],
        ),),
    );
  }
}