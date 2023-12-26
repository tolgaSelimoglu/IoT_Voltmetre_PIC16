


import 'package:flutter/material.dart';
import 'package:picoxiloscope/core/constants/custom_styles.dart';
import 'package:sparkline/sparkline.dart';

class MySensorCard extends StatelessWidget {
  const MySensorCard(
      {Key? key,
      required this.value,
      required this.name,
      //required this.assetImage,
      required this.unit,
      required this.trendData,
      required this.linePoint})
      : super(key: key);

  final String value;
  final String name;
  final String unit;
  final List<double> trendData;
  final Color linePoint;
  //final AssetImage assetImage;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: Colors.white,
        elevation: 24,
        color: Colors.black,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image(
                    //   width: 60,
                    //   image: assetImage,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(name, style: kBodyText.copyWith(color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('$value $unit',
                        style: kHeadline.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                  child: Sparkline(
                    data: trendData,
                    lineWidth: 3.0,
                    lineColor: Colors.white,
                    //averageLine: true,
                    fillMode: FillMode.below,
                    sharpCorners: false,
                    pointsMode: PointsMode.last,
                    pointSize: 15,
                    pointColor: linePoint,
                    //useCubicSmoothing: true,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}