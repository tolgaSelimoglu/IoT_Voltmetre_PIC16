import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:picoxiloscope/models/saved_data_model.dart';

class SavedDataPage extends StatefulWidget {
  const SavedDataPage({super.key});

  @override
  State<SavedDataPage> createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text("Picoxiloscope", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body:_buildBody(context) ,
    );
  }
  
  _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildListView(context)
      ],
    );



  }
  
  
  Widget _buildListView(BuildContext context) {
    //Box contactBox = Hive.box("savedData");
final savedData = Hive.box("savedData");
          
            return Expanded(
              child: ListView.builder(
                    itemCount: savedData.length,
                    itemBuilder: (context, index){
                      final savedDatab = savedData.getAt(index) as SavedDataModel;
                       return Card(
                        elevation: 1,
                        color: savedDatab.type == "Amp" ? Color(0xFF63ED78) : Color(0xFFED6484) ,
                        margin: const EdgeInsets.all(10),
                         child: ListTile(
                                               leading: CircleAvatar(
                                     backgroundColor: Colors.white,
                                     child: Text(savedDatab.type),
                                   ),
                                               title: Text(savedDatab.value),
                                               subtitle: Text(DateFormat.yMd().add_jm().format(savedDatab.time) ),
                                               trailing: MaterialButton(
                          child: Icon(Icons.delete, color: Colors.black,),
                           onPressed: (){
                                          
                                          setState(() {
                                            savedData.deleteAt(index);
                                          });
                                        },
                          )
                                             ),
                       );
                  }),
            );
      
   
  }
}