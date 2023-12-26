part of 'sensor_data_bloc.dart';

sealed class SensorDataState extends Equatable {
  const SensorDataState();
  
  @override
  List<Object> get props => [];
}

final class SensorDataInitial extends SensorDataState {}

class SensorDataLoading extends SensorDataState{}

class SensorDataLoaded extends SensorDataState{
  final String data;

  SensorDataLoaded({required this.data});

  @override
  List<Object> get props => [data];

}

class SensorDataFailded extends SensorDataState{
  final String message;
  SensorDataFailded(this.message);

  @override
  List<Object> get props => [message];
}