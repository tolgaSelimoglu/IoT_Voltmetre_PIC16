import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:picoxiloscope/core/constants/colors_constants.dart';
import 'package:picoxiloscope/core/constants/custom_styles.dart';
import 'package:picoxiloscope/models/saved_data_model.dart';
import 'package:picoxiloscope/pages/saved_data_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AmpermeterPage extends StatefulWidget {
  const AmpermeterPage({super.key});

  @override
  State<AmpermeterPage> createState() => _AmpermeterPageState();
}

class _AmpermeterPageState extends State<AmpermeterPage> {

   String amperData = "";
   double amperDouble = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  //List<double> voltage = List.filled(5, 0 , growable: true);
  bool isPaused = false;
  double pausedAmper = 0;
 
  _activateListner(){
    
 try{_streamSubscription = ref.child("ampere").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
       
      setState(() {
        amperData = data.toString();
      }); 
          amperDouble = double.parse(amperData) ;
          //voltage.add(amperDouble);
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
          animationDuration: 100,
          axes: <RadialAxis>[
            RadialAxis(minimum: -30, maximum: 30, 
           // backgroundImage: AssetImage("assets/images/ytu_logo2.png",),
          pointers: <GaugePointer>[
              NeedlePointer(value: isPaused ? pausedAmper: amperDouble, enableAnimation: true)
            ], 
          ranges: <GaugeRange>[            
              GaugeRange(startValue: -30, endValue: -22.5, color: Colors.red),
              GaugeRange(startValue: -22.5, endValue: -12.5, color: Colors.orange),
              GaugeRange(startValue: -12.5, endValue: 12.5, color: Colors.green),
              GaugeRange(startValue: 12.5, endValue: 22.5, color: Colors.orange),
              GaugeRange(startValue: 22.5, endValue: 30, color: Colors.red),
            ], annotations: <GaugeAnnotation>[
               GaugeAnnotation(
                  widget: Text(
                    'Ampermeter',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.5,
                  angle: 90)
            ]),
          ],
        ),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text( isPaused ? "$pausedAmper" : "$amperDouble", style: kBodyTextBlack),
                                const SizedBox(width: 25,),
                                const Text("A", style: TextStyle(color: Color(0xFFE4BE9E), fontSize: 20)),
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
                                color: ColorConstants.buttonColor,

                                onPressed: (){

                                  if (!isPaused) {
                                    isPaused = true;
                                    pausedAmper = amperDouble;
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
                                  String value = isPaused ? pausedAmper.toString() : amperDouble.toString();
                                  String type = "Amp";
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