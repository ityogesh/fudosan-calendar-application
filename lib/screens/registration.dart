import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';

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
                style: TextStyle(
                    color: ColorConstant.rButton,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
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
                      color: Colors.white,
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
                            "display": "賃貸",
                            "value": "賃貸",
                          },
                          {
                            "display": "販売（売買）",
                            "value": "販売（売買）",
                          },
                          {
                            "display": "企画開発",
                            "value": "企画開発",
                          },
                          {
                            "display": "資産運用",
                            "value": "資産運用",
                          },
                          {
                            "display": "賃貸管理",
                            "value": "賃貸管理",
                          },
                          {
                            "display": "物流",
                            "value": "物流",
                          },
                          {
                            "display": "総務・経理",
                            "value": "総務・経理",
                          },
                          {
                            "display": "その他",
                            "value": "その他",
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
                  labelText: '部署名（任意）',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    '登録完了',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: ColorConstant.rButton,
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
