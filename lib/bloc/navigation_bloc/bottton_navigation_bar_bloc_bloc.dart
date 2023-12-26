
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottton_navigation_bar_bloc_event.dart';
part 'bottton_navigation_bar_bloc_state.dart';

class BottomNavigationBarBloc extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {

//int selectedIndex = 0;

  BottomNavigationBarBloc() : super(BottonNavigationBarBlocInitial(0)) {


    on<OndestinationSelectEvent>((event, emit) {
      emit(OndestinationSelectState(index: event.index));
    });

  }


}
