import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:picoxiloscope/models/sensor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OsciloscopePage extends StatefulWidget {
  const OsciloscopePage({super.key});

  @override
  State<OsciloscopePage> createState() => _OsciloscopePageState();
}

class _OsciloscopePageState extends State<OsciloscopePage> {
   late ChartSeriesController _chartSeriesController;
    String voltageData = "";
   double voltageDouble = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  List<double> voltage = List.filled(5, 0 , growable: true);
  late List<VoltageChartData> voltageChartData  ;
   late Timer _timer;
   late ZoomPanBehavior _zoomPanBehavior;
   

 
  _activateListner(){

    _timer = Timer.periodic(const Duration(seconds: 1), updateDataSource);
    _zoomPanBehavior = ZoomPanBehavior(
                  // Enables pinch zooming
                  enablePinching: true
                );
    voltageChartData = getChartData();
    
    
 try{_streamSubscription = ref.child("voltage").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
       
      setState(() {
        voltageData = data.toString();

        voltageDouble = double.parse(voltageData) ;
          // int x = 3;
          // x += 1; 
          //voltageChartData.add(VoltageChartData(x, voltageDouble));
          //voltageChartData.removeAt(0);
      }); 
          

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

  @override
  void dispose() {
   _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Picoxiloscope", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body:_buildBody() ,
    );
  }

  
  
  _buildBody() {
    return Center(
                child: SfCartesianChart(
                  zoomPanBehavior: _zoomPanBehavior,
                  // plotAreaBackgroundImage: AssetImage("assets/images/ytu_logo2.png",),
                                series: <CartesianSeries>[
                          SplineSeries<VoltageChartData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _chartSeriesController = controller;
                            },
                            dataSource: voltageChartData,
                            splineType: SplineType.cardinal,
                            cardinalSplineTension: 0.9,
                            color: const Color.fromRGBO(192, 108, 132, 1),
                            xValueMapper: (VoltageChartData data, _) => data.x,
                            yValueMapper: (VoltageChartData data, _) => data.y
                          )
                        ],
                primaryXAxis: const NumericAxis(
                
                majorGridLines:  MajorGridLines(width: 1),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                interval: 1,
                title: AxisTitle(text: 'Time (ms)')),
                primaryYAxis: const NumericAxis(
                //isVisible: false,
                axisLine:  AxisLine(width: 0),
                majorTickLines:  MajorTickLines(size: 0),
                title: AxisTitle(text: 'Voltage (V)')))
                );
  }



  int time = 12;
  void updateDataSource(Timer timer) {
    voltageChartData.add(VoltageChartData(time++, voltageDouble ));
    voltageChartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: voltageChartData.length - 1, removedDataIndex: 0);
  }


  List<VoltageChartData> getChartData(){
    return [ 
    VoltageChartData(0, 0),
    VoltageChartData(1, 0),
    VoltageChartData(2, 0),
    VoltageChartData(3, 0),
    VoltageChartData(4, 0),
    VoltageChartData(5, 0),
    VoltageChartData(6, 0),
    VoltageChartData(7, 0),
    VoltageChartData(8, 0),
    VoltageChartData(9, 0),
    VoltageChartData(10, 0),
    VoltageChartData(11, 0),
   ];
  }
}



 