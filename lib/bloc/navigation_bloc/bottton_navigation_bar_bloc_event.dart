part of 'bottton_navigation_bar_bloc_bloc.dart';

sealed class BottomNavigationBarEvent extends Equatable {
  
   const BottomNavigationBarEvent();
  //int index;
  @override
  List<Object> get props => [];
}


// ignore: must_be_immutable
class OndestinationSelectEvent extends BottomNavigationBarEvent {
  int index;
  OndestinationSelectEvent({required this.index});
} 