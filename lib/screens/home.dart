import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/screens/add.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

getuid() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = await auth.currentUser!;
  setState(() {
    uid = user.uid;
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List")
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(), builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
             final docs = snapshot.data!;
             return ListView.builder(itemCount: docs.size,
             itemBuilder: (context, Index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 63, 138, 100), ),
                height: 90,
                
                child: Column(
                  children: [
                    Text(docs.docs[Index]['name']),
                    //Text(docs.docs[Index]['description']),
                  ],
                ),
              );
             },);
          }
        }),
        color: Color.fromARGB(255, 116, 112, 111),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        },
        child: Icon(Icons.add, color: Colors.white,),
      )
    );
  }
}