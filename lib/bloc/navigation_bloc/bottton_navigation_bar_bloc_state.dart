part of 'bottton_navigation_bar_bloc_bloc.dart';

// ignore: must_be_immutable
sealed class BottomNavigationBarState extends Equatable {

  int index;
   BottomNavigationBarState(this.index);
  
  @override
  List<Object> get props => [index];
}

// ignore: must_be_immutable
final class BottonNavigationBarBlocInitial extends BottomNavigationBarState {
  BottonNavigationBarBlocInitial(index): super(index);
}

// ignore: must_be_immutable
class OndestinationSelectState extends BottomNavigationBarState{
  
  OndestinationSelectState({required index}): super(index);
}
