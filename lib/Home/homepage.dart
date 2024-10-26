
import 'package:flutter/material.dart';
import 'package:rideadmin/LoginPage/login.dart';

class Homepage extends StatelessWidget {
   const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Text('home page '),
      leading: IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));}, icon:Icon(Icons.arrow_back)),
     ),
    );
  }
}