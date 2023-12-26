import 'dart:async';



import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picoxiloscope/bloc/sensor_bloc/sensor_data_bloc.dart';
import 'package:picoxiloscope/core/constants/custom_styles.dart';
import 'package:picoxiloscope/services/firebase_services.dart';
import 'package:picoxiloscope/widgets/my_sensor_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String voltageData = "";
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  List<double> voltage = List.filled(5, 0.0 , growable: true);

 
  _activateListner(){
    
  try{_streamSubscription = ref.child("voltage").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("voltageeeeeeeeeeeeeee $data");
       
      setState(() {
        voltageData = data.toString();
      }); 

          voltage.add(double.parse(voltageData));
          voltage.removeAt(0);
        
      
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







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Osciloscope", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
        centerTitle: true,


      ),
      body: _buildbody(),
    );
  }

  _buildBody() {
    return BlocConsumer<SensorDataBloc, SensorDataState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        String data = "";
        if (state is SensorDataLoading){
          data = "Loading";
        }
        if (state is SensorDataLoaded){
          data = state.data;
        }
        if (state is SensorDataFailded){
          data = state.message;
        }
        return Container(
          child: Center(
            child: Text("Voltage: $data"),
          ),
        );
      },
    );
  }

  _buildbody(){
          
      return  Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Text(
                            "Pic",
                            style:  kHeadline,
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Testttt",
                            style: kHeadline,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MySensorCard(
                                value: voltageData,
                                unit: 'V',
                                name: 'Voltage',
                                // assetImage: AssetImage(
                                //   'assets/images/humidity_icon.png',
                                // ),
                                trendData: voltage,
                                linePoint: Colors.blueAccent,
                              ),
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ) ,
        );
    
    
  }
          
     
    
    
  
}


