import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import 'package:login_fudosan/screens/loginscreen.dart';

import 'otp_registration.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _myActivity;

  final formKey = new GlobalKey<FormState>();
  void initState() {
    super.initState();
    _myActivity = '';
  }

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
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
              child: Text(
                'ログインヘ',
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '新規ユーザー登録',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: '氏名*',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(
                  labelText: 'メールアドレス*',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: 'パスワード*',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: 'パスワードの再確認*',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: '会社名*',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
//                    padding: EdgeInsets.all(16),
                      child: DropDownFormField(
                        titleText: null,
                        hintText: 'その他',
                        onSaved: (value) {
                          setState(() {
                            _myActivity = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _myActivity = value;
                          });
                        },
                        dataSource: [
                          {
                            "display": "1",
                            "value": "1",
                          },
                          {
                            "display": "2",
                            "value": "2",
                          },
                          {
                            "display": "3",
                            "value": "3",
                          },
                          {
                            "display": "4",
                            "value": "4",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: '部署名*',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    '登録完了',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OtpRegistrationScreen()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
