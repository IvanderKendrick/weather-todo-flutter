import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff2f0c8),
      appBar: AppBar(
        leading: Image.asset('assets/logo_Swhite2.png'),
        title: Text(
          "do's here, hi ken!",
          style: TextStyle(fontFamily: 'BebasNeue'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff36a5b2), Color(0xff36a5b2)],
            stops: [0.25, 0.75],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('tasks').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          //OLAH DATA
          var _data = snapshots.data!.docs;

          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  _data[index].reference.delete().then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task Removed'))));
                },
                title: cardGenerator(_data[index].data()['task']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff00e4ff),
        shape: CircleBorder(),
        onPressed: () {
          _showInputPopup(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showInputPopup(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight * 0.5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: halfScreenHeight,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(labelText: 'Enter your task'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String newTask = _textController.text.trim();

                    if (newTask.isNotEmpty) {
                      // Add the new task to Firestore
                      db.collection("tasks").add({"task": newTask}).then(
                        (DocumentReference) => print(
                            'DocumentSnapshot added with ID: ${DocumentReference.id}'),
                      );

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    } else {
                      // Handle empty task input (you can show an error message)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid task')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Card cardGenerator(String task) {
    return Card(
      color: Color(0xfff5f4ed),
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              task,
              style: TextStyle(fontSize: 16.0),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Long Press to Delete')));
            },
            icon: Icon(Icons.delete),
            color: Color(0xff005b66),
          )
        ],
      ),
    );
  }
}
