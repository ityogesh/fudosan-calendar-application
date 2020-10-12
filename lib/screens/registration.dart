import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:login_fudosan/screens/loginscreen.dart';

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
                'ログイン',
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '新規ユーザー登録',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
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
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelText: 'パスワード*',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelText: 'パスワードの再確認*',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
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
//                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      hintText: '部署名',
                      titleText: '',
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
                          "display": "Running",
                          "value": "Running",
                        },
                        {
                          "display": "Climbing",
                          "value": "Climbing",
                        },
                        {
                          "display": "Walking",
                          "value": "Walking",
                        },
                        {
                          "display": "Swimming",
                          "value": "Swimming",
                        },
                        {
                          "display": "Soccer Practice",
                          "value": "Soccer Practice",
                        },
                        {
                          "display": "Baseball Practice",
                          "value": "Baseball Practice",
                        },
                        {
                          "display": "Football Practice",
                          "value": "Football Practice",
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
                  print('Hi');
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

  showPalmUploadAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here

          child: Container(
            padding: EdgeInsets.all(15),
            height: 200,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
//              color: Colors.lightBlueAccent,
                    color: Colors.transparent,

                    blurRadius: 500.0,

//             offset: Offset(6.6, 7.8),
                  ),
                ]),
            child: Column(
              children: [
                Image.asset("assets/images/pop.PNG"),
                SizedBox(
                  height: 10,
                ),
                Text('パスワードを変更いたしました。'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    );
  }
}
