import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_fudosan/models/loginResponseModel.dart';
import 'package:login_fudosan/screens/homescreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'registration.dart';
import 'forget_password.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RegistrationScreen()));
              },
              child: Text(
                'ユーザー登録',
                style: TextStyle(
                    color: ColorConstant.lButton,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      Text(
        'ようこそ',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25.0),
      ),
      Text('アプリを使用するにはログインしてください。'),
      SizedBox(
        height: 7,
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          labelText: 'メールアドレス',
        ),
      ),
      SizedBox(
        height: 7,
      ),
      TextFormField(
        obscureText: false,
        decoration: new InputDecoration(
          labelText: 'パスワード',
        ),
      ),
      SizedBox(
        height: 20,
      ),
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ResetPassword()));
        },
        child: Text(
          'パスワードを忘れた方はこちら',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      SizedBox(
        height: 22,
      ),
      Container(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          child: Text(
            'ログイン',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: ColorConstant.lButton,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreeen()));
            //_loginInitiate();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      )
            ],
          ),
        ),
    );
  }

  _loginInitiate() async {
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var data = '{"email":"nadal11114@yopmail.com","password":"npassword"}';

    var res =
        await http.post(Constants.login_URL, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    print(res.body);
    LoginResponseModel loginResponseModel =
        LoginResponseModel.fromJson(json.decode(res.body));
    print('success');
    /*  var responsedata = json.decode(res.body);
    print(responsedata['success']);
    print(responsedata['UserDetails']['id']);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreeen())); */
  }
}
