import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:mobilefinal2/db/user_db_model.dart';
import '../utils/current.dart';
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
  UserUtils user = UserUtils();
  String _user_id = ""; 

  @override
  void initState(){
    super.initState();
    isLogin();
  }

  Future<void> isLogin() async{
    await _getUsername();
    if (this._user_id != ""){
      await _autoLogin();
    }
  }
  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null){
      setState(() {
       this._user_id = ""; 
      });
    } else {
      setState(() {
       this._user_id = username; 
      });
    }
  }

  Future<void> _autoLogin() async {
    await user.open("user.db");
    Future<List<UserModel>> allUser = user.getAllUser();
    var userList = await allUser;
    for(var i=0; i < userList.length;i++){
      if (this._user_id == userList[i].userid){
        CurrentUser.ID = userList[i].id;
        CurrentUser.USERID = userList[i].userid;
        CurrentUser.NAME = userList[i].name;
        CurrentUser.AGE = userList[i].age;
        CurrentUser.PASSWORD = userList[i].password;
        CurrentUser.QUOTE = userList[i].quote;
        print("this user valid");
        break;
      }
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> getUsername() async{
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if(username == null){
      setState(() {
       this._user_id = "";
      });
    }else{
      setState(() {
       this._user_id = username; 
      });
    }
  }
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
                await user.open('user.db');
                Future<List<UserModel>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (userid == userList[i].userid && password == userList[i].password){
                      CurrentUser.ID = userList[i].id;
                      CurrentUser.USERID = userList[i].userid;
                      CurrentUser.NAME = userList[i].name;
                      CurrentUser.AGE = userList[i].age;
                      CurrentUser.PASSWORD = userList[i].password;
                      CurrentUser.QUOTE = userList[i].quote;
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('username', userList[i].userid);
                      this.isvalid = true;
                      print("this user valid");
                      break;
                    }
                  }
                }
                if(this.formState != 2){
                  Toast.show("Please fill this form", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  
                  this.formState = 0;

                }else{
                  this.formState = 0;
                  print("${userid.text} and ${password.text}");
                  await isUserValid(userid.text, password.text);
                  if(!this.isvalid){
                    Toast.show("Invalid user or password", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.blue,textColor: Colors.red);
                  }else{
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }
                Future showAllUser() async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    print(userList[i]);
                    }
                  }

                showAllUser();
                print(CurrentUser.whoCurrent());
              
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