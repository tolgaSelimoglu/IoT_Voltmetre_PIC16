import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:picoxiloscope/bloc/navigation_bloc/bottton_navigation_bar_bloc_bloc.dart';
import 'package:picoxiloscope/bloc/sensor_bloc/sensor_data_bloc.dart';
import 'package:picoxiloscope/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:picoxiloscope/firebase_options.dart';
import 'package:picoxiloscope/models/saved_data_model.dart';
import 'package:picoxiloscope/pages/navigation_bar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
 Hive.registerAdapter(SavedDataModelAdapter());
  final savedData = await Hive.openBox("savedData");



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context) => SignUpBloc() ),
        BlocProvider(create:(context) => SensorDataBloc() ),
        BlocProvider(create:(context) => BottomNavigationBarBloc() ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: NavigationScreen(),
      ),
    );
  }
}
