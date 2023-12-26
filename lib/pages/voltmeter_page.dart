import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:picoxiloscope/core/constants/colors_constants.dart';
import 'package:picoxiloscope/core/constants/custom_styles.dart';
import 'package:picoxiloscope/models/saved_data_model.dart';
import 'package:picoxiloscope/pages/saved_data_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class VoltmeterPage extends StatefulWidget {
  const VoltmeterPage({super.key});

  @override
  State<VoltmeterPage> createState() => _VoltmeterPageState();
}

class _VoltmeterPageState extends State<VoltmeterPage> {

   String voltageData = "";
   double voltageDouble = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  //List<double> voltage = List.filled(5, 0 , growable: true);
  bool isPaused = false;
  double pausedVolt = 0;
 
  _activateListner(){
    
 try{_streamSubscription = ref.child("voltage").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
       
      setState(() {
        voltageData = data.toString();
      }); 
          voltageDouble = double.parse(voltageData) ;
          //voltage.add(voltageDouble);
          //voltage.removeAt(0);
        
      
  });
  } catch(e){
    print(e.toString());
  }

  }

  @override
  void initState() {
    _activateListner();
    super.initState();
  }

  @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }


   addSavedData(SavedDataModel savedData){
  Box savedDataBox = Hive.box("savedData");
  savedDataBox.add(savedData);
  //print("It wokedddddddddddddddd");
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Picoxiloscope", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
        centerTitle: true,
         actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'saved data',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedDataPage()),
  );
            },
          ),
        ],
      ),
      body:_buildBody() ,
    );
  }


_buildBody(){
          
      return  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flexible(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SfRadialGauge(
          // title: GaugeTitle(
          //     text: 'Speedometer',
          //     textStyle:
          //         TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          enableLoadingAnimation: true,
          animationDuration: 50,
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 50, 
           // backgroundImage: AssetImage("assets/images/ytu_logo2.png",),
          pointers: <GaugePointer>[
              NeedlePointer(value: isPaused ? pausedVolt: voltageDouble, enableAnimation: true)
            ], 
          ranges: <GaugeRange>[
             // GaugeRange(startValue: 0, endValue: 7.5, color: Colors.red),
             // GaugeRange(startValue: 7.5, endValue: 17.5, color: Colors.orange),
              GaugeRange(startValue: 0, endValue: 32.5, color: Colors.green),
              GaugeRange(startValue: 32.5, endValue: 42.5, color: Colors.orange),
              GaugeRange(startValue: 42.5, endValue: 50, color: Colors.red)
              
            ], annotations: const <GaugeAnnotation>[
              GaugeAnnotation(
                  widget:  Text(
                    'Voltmeter',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.5,
                  angle: 90),
            ]),
          ],
        ),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text( isPaused ? "$pausedVolt" : "$voltageDouble", style: kBodyTextBlack),
                                const SizedBox(width: 25,),
                                const Text("V", style: TextStyle(color: Color(0xFFE4BE9E), fontSize: 20)),
                            ],
                          ),
                        ),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                child: Text("Pause", style: kButtonText,),
                                //color: Colors.red,
                                color: isPaused? Colors.teal.shade100 : ColorConstants.buttonColor,

                                onPressed: (){
                                  setState(() {
                                    
                                  });
                                  if (!isPaused) {
                                    isPaused = true;
                                    pausedVolt = voltageDouble;
                                  }else{
                                    isPaused = false;
                                  }

                                },),
                            
                                SizedBox(width: 20,),
                            
                                MaterialButton(
                                child: Text("Save", style: kButtonText,),
                                //color: Colors.red.shade500,
                                color: ColorConstants.buttonColor,
                                onPressed: (){
                                  String value = isPaused ? pausedVolt.toString() : voltageDouble.toString();
                                  String type = "Volt";
                                  DateTime time = DateTime.now();
                                  SavedDataModel savedData = SavedDataModel(value: value, type: type, time: time);
                                  addSavedData(savedData);

                                },),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ) ,
        );
    
    
  }



}