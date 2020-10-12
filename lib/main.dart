import 'package:flutter/material.dart';
import 'package:login_fudosan/registration.dart';

import 'forget_password.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ようこそ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              Text('アプリを使用するにはログインしてください。'),
              SizedBox(
                height: 7,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: 'メールアドレス',
                ),
              ),
              SizedBox(
                height: 7,
              ),
              TextFormField(
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: 'パスワード',
                ),
              ),
              SizedBox(
                height: 10,
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
                height: 18,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    'ログイン',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    print('click me');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              )
              /*MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.white)),
                    onPressed: () {
                      print('click me');
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Text(
                      'ログイン',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),*/
            ],
          ),
        ),
      ),
    );
  }
}
