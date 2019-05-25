import 'package:flutter/material.dart';
import 'package:mobilefinal2/ui/friends_screen.dart';
import 'package:mobilefinal2/ui/home_screen.dart';
import 'package:mobilefinal2/ui/login_screen.dart';
import 'package:mobilefinal2/ui/profile_screen.dart';
import 'package:mobilefinal2/ui/register_screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'mobilefinal2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/friend': (context) => FriendScreen(),
        
      },
    );
  }

}