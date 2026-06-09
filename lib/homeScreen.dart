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
      backgroundColor: Color(0xFF1C1B1B),
      appBar: AppBar(
        title: Text("Hive Database", style: TextStyle(
          color: Color(0xFFBB86FC)
        ),),
        backgroundColor:Color(0xFF000000),
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
                color: Color(0xFF313030),
                child: Padding(
                  
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              viewNote(data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString()
                                    );
                            },
                            
                            child: Column(
                              children: [
                                Text(data[index].title.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                                ),),
                                Text(data[index].description.toString())
                            
                            
                              ],
                            ),
                          ),
                           
                           Spacer(),

                           Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF006A60)
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  updateDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString(),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xFF4FFBE6),
                                ),
                              ),
                            ),

                           ),
                           SizedBox(width: 5,),


                           Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(250, 197, 197, 1)
                            ),
                            child: Center(
                              child: 
                           IconButton(onPressed: (){
                            delete(data[index]);

                           }, 
                                icon: Icon(Icons.delete, 
                                size: 20,
                                color: Colors.red),
                              )

                            ),

                           ),

                           
                        ],
                      ),
                     
                      
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


//        Dialog for Adding Notes  

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


  //  Delete Function

  void delete (NotesModel notesmodel)async{
   await  notesmodel.delete();
  }



//          Dialog for Updating Notes

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



  //  Dialog for Viewing Notes


  
  Future<void> viewNote (NotesModel notesmodel, String title, String des) async {

    titleController.text = title;
    descController.text = des;

    return showDialog(
      context: context,
       builder: (context){
       
       return AlertDialog(
        title: Text(title),
        content: Text(des),
        actions: [

           TextButton(onPressed: (){
            Navigator.pop(context);
           },
            child: Text("Exit"))

        ],
       );
        
       }
       );
  }

}