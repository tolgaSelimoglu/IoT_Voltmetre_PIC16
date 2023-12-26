import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picoxiloscope/services/firebase_services.dart';

part 'sensor_data_event.dart';
part 'sensor_data_state.dart';

class SensorDataBloc extends Bloc<SensorDataEvent, SensorDataState> {
  SensorDataBloc() : super(SensorDataInitial()) {
    on<SensorDataRequ>((event, emit) async {
      emit(SensorDataLoading());
      try {
        final data = await FirebaseServices.readVoltage();
        emit(SensorDataLoaded(data: data));
      } catch (e) {
        emit(SensorDataFailded(e.toString()));
      }
    });
  }
}
