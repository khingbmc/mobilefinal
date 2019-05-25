import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }

}


 class LoginScreenState extends State<LoginScreen>{
  final _formkey = GlobalKey<FormState>();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isvalid = false; //check validate
  int formState = 0;
  String _user_id = "";

  // @override
  // void initState(){
  //   super.initState();
  //   isLogin();
  // }

  // Future<void> isLogin() async{
  //   await 
  // }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          children: <Widget>[
            Image.asset(
              "assets/cat.jpg",
              width: 200,
              height: 200,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                icon: Icon(Icons.account_box, size:30, color: Colors.grey)
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (val) {
                if(val.isNotEmpty){
                  this.formState++;
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock, size: 30, color: Colors.grey),
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (val){
                if(val.isNotEmpty){
                  this.formState++;
                }
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: () async{
                _formkey.currentState.validate();
                

                if(this.formState != 2){
                  Toast.show("Please fill this form", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;

                }else{
                  this.formState = 0;
                  print("${userid.text} and ${password.text}");
        
                }
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register New Account", textAlign: TextAlign.right),
              ),
              onPressed: (){
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 150.0),
            ),
          ],
        ),
      ),
    );
  }
    
  }