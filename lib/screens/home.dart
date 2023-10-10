import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/screens/add.dart';
import 'package:todo_list/screens/description.dart';

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
        title: Text("To-Do List"),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(Icons.logout, color: Colors.white,))
        ],
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
              var time = DateTime.parse(docs.docs[Index]['time']);
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(title: docs.docs[Index]['name'], description: docs.docs[Index]['description'],)));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xff121211), ),
                  height: 90,
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(docs.docs[Index]['name'], style: GoogleFonts.roboto(fontSize: 20),)),
                          SizedBox(height: 5,),
                          Container(
                            margin: EdgeInsets.only(left: 20), 
                            child: Text(DateFormat.yMd().add_jm().format(time)),),
                        ],
                      ),
                      Container(child: IconButton(icon: Icon(Icons.delete, color: Color.fromARGB(255, 151, 26, 17),), onPressed: () async{
                        await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').doc(docs.docs[Index]['time']).delete();
                      },),)
                    ],
                  ),
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