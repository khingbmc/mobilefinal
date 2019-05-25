import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'friendtodo_screend.dart';

class FriendScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FriendScreenState();
  }

}

class FriendScreenState extends State<FriendScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('All My Friends'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Text("BACK"),
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            FutureBuilder(
              future: fetchUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('Wait a second...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<UserModel> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${(values[index].id).toString()} : ${values[index].name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 5)),
                Text(
                  values[index].email,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  values[index].phone,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  values[index].website,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendTodoScreen(id: values[index].id),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }

}

Future<List<UserModel>> fetchUser() async{
  final res = await http.get('https://jsonplaceholder.typicode.com/users');

  List<UserModel> userApi = [];
  if (res.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(res.body);
    for(int i = 0; i< body.length;i++){
      var user = UserModel.fromJson(body[i]);
      userApi.add(user);
    }
    return userApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed');
  }

}

class UserModel{
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  UserModel({this.id, this.name, this.email, this.phone, this.website});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}
