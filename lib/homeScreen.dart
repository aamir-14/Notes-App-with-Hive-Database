import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app_with_hive/Models/notes_model.dart';
import 'package:notes_app_with_hive/boxes/box1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive Database"),
        backgroundColor: Colors.amberAccent,
      ),

      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Box1.getData().listenable(),
         builder: (context , Box , _){

          var data = Box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: Box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                           Text(data[index].title.toString()),

                           Spacer(),

                           IconButton(onPressed: (){
                            updateDialog(data[index], data[index].title.toString(), data[index].description.toString());

                           }, 
                           icon: Icon(Icons.edit)),

                           IconButton(onPressed: (){
                            delete(data[index]);

                           }, 
                           icon: Icon(Icons.delete, color: Colors.red,))

                        ],
                      ),
                     
                      Text(data[index].description.toString())
                    ],
                  ),
                ),
                
              );
            }
            );
         }
         ),




      floatingActionButton: FloatingActionButton(onPressed: (){

        showmyDialogue();

      },
      
      child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showmyDialogue () async {

    return showDialog(
      context: context,
       builder: (context){
       
       return AlertDialog(
        title: Text(" Add Note"),
        content: SingleChildScrollView(
          child: Column(

            children: [

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Title"
                
                ),
              ),

              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Enter Description"
                
                ),
              )


            ],

          ),
        ),
        actions: [
          TextButton(onPressed: (){
             Navigator.pop(context);
          },
           child: Text("Cancel")
           ),

           TextButton(onPressed: (){
           final data = NotesModel(title: titleController.text, description: descController.text);

           final box = Box1.getData();
           box.add(data);

           titleController.clear();
           descController.clear();

           Navigator.pop(context);

           //data.save();

           


           },
            child: Text("Add"))

        ],
       );
        
       }
       );
  }

  void delete (NotesModel notesmodel)async{
   await  notesmodel.delete();
  }


  Future<void> updateDialog (NotesModel notesmodel, String title, String des) async {

    titleController.text = title;
    descController.text = des;

    return showDialog(
      context: context,
       builder: (context){
       
       return AlertDialog(
        title: Text(" Add Note"),
        content: SingleChildScrollView(
          child: Column(

            children: [

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Title"
                
                ),
              ),

              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Enter Description"
                
                ),
              )


            ],

          ),
        ),
        actions: [
          TextButton(onPressed: (){
             Navigator.pop(context);
          },
           child: Text("Cancel")
           ),

           TextButton(onPressed: (){

            notesmodel.title = titleController.text.toString();
            notesmodel.description = descController.text.toString();

            notesmodel.save();

            titleController.clear();
            descController.clear();
            Navigator.pop(context);
           
           


           },
            child: Text("Update"))

        ],
       );
        
       }
       );
  }

}