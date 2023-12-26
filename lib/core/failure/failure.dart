
import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {

  final String message;
   Failure({required this.message});
  
  @override
  List<Object?> get props => [message];
}