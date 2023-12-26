import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picoxiloscope/bloc/navigation_bloc/bottton_navigation_bar_bloc_bloc.dart';
import 'package:picoxiloscope/pages/ampermeter_page.dart';
import 'package:picoxiloscope/pages/home_page.dart';
import 'package:picoxiloscope/pages/osciloscope_page.dart';
import 'package:picoxiloscope/pages/voltmeter_page.dart';


class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBarBloc, BottomNavigationBarState>(
      //bloc: BottomNavigationBarBloc(),
      builder: (context, state) {
        int pageIndex = state.index;
    
        return Scaffold(
          body: _nagitionBody(pageIndex),
          bottomNavigationBar: _bottomNavigatiomBar(context, pageIndex),
        );
      },
    );
  }

  _bottomNavigatiomBar(context, index) {
    return NavigationBar(
      selectedIndex: index,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) =>
            BlocProvider.of<BottomNavigationBarBloc>(context)
                .add(OndestinationSelectEvent(index: index)),
        destinations: [
          NavigationDestination(
          //     icon: Image(
          //     image: AssetImage(PathConstants.home),
          //   color: index == 0 ? Colors.blue.shade500 : null,
          // ),
          icon: Icon(Icons.energy_savings_leaf, 
          color: index == 0 ? Colors.blue.shade500 : null,
          ),
            label: 'voltmeter',
          ),

          NavigationDestination(
          //   icon: Image(
          //     image: AssetImage(PathConstants.workouts),
          //     color: index == 1 ? Colors.blue.shade500 : null,
          // ),
          icon: Icon(Icons.energy_savings_leaf_rounded, 
          color: index == 1 ? const Color.fromARGB(255, 33, 150, 243) : null,
          ),
            label: 'ampermeter',
          ),

          NavigationDestination(
          //   icon: Image(
          //     image: AssetImage(PathConstants.settings),
          //     color: index == 2 ? Colors.blue.shade500 : null,
          // ),
          icon: Icon(Icons.display_settings_rounded, 
          color: index == 2 ? Colors.blue.shade500 : null,
          ),
            label: 'osciloscope',
          ),
        ]);
  }

  _nagitionBody(int pageindex) {
    return [
      VoltmeterPage(),
      AmpermeterPage(),
      OsciloscopePage(),
    ][pageindex];
  }
}
