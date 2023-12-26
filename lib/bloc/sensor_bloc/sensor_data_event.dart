part of 'sensor_data_bloc.dart';

sealed class SensorDataEvent extends Equatable {
  const SensorDataEvent();

  @override
  List<Object> get props => [];
}

class SensorDataRequ extends SensorDataEvent{}