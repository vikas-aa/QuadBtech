import 'package:flutter/material.dart';
import 'package:quadbtech/detailsscreen.dart';
import 'package:quadbtech/homescreen.dart';
import 'package:quadbtech/searchscreen.dart';
import 'package:quadbtech/splashscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) =>SearchScreen(),
        '/details': (context) =>DetailsScreen()
      },
    );
  }
}
