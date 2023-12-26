import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picoxiloscope/bloc/sensor_bloc/sensor_data_bloc.dart';
import 'package:picoxiloscope/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:picoxiloscope/pages/home_page.dart';
import 'package:picoxiloscope/widgets/common_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

@override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }


  _buildBody() {

    return BlocConsumer<SignUpBloc, SignUpState>( 
      
    listener:(context, state) {
      if (state is SignUpSucceded){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(),));
          } 

          if (state is SignUpFailed){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
      
    },
    builder: (context, state) {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

             Text("Picoxiloscope", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                
            Column(

              children: [
                
                CommonTextField(
                  title: "İsim",
                  controller: _nameController,
                  placeholder: "İsminizi giriniz",
                  onTextChanged: () {},
                  errorText: "lala",
                  keyboardType: TextInputType.name,
                  
                  ),
                  SizedBox(height: 10,),

                  CommonTextField(
                  title: "Mail",
                  controller: _emailController,
                  placeholder: "Mailinizi giriniz",
                  onTextChanged: () {},
                  errorText: "lala",
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  
                  ),

                  SizedBox(height: 10,),

                  CommonTextField(
                  title: "Şifre",
                  controller: _passwordController,
                  placeholder: "En 6 haneli şifre giriniz",
                  onTextChanged: () {},
                  errorText: "lala",
                  obscureText: true,
                  
                  ),
                
          

              ],
            ),
      
            MaterialButton(
            color: Colors.blue.shade500,  
            onPressed: (){
              String name = _nameController.text;
              String email = _emailController.text;
              String password = _passwordController.text;
              //BlocProvider.of<SignUpBloc>(context).add(SignUp(name: name, email: email, password: password));
              //BlocProvider.of<SensorDataBloc>(context).add(SensorDataRequ());
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(),));
            },
            child: const Text("Giriş Yap"),
            )
          ],
        ),
      );
    },
    );
  }
}
