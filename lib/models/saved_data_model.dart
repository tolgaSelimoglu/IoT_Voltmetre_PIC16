
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'saved_data_model.g.dart';

@HiveType(typeId: 0)
class SavedDataModel {
  @HiveField(0)
  final String value;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final DateTime time;

  SavedDataModel({required this.value, required this.type, required this.time});
}