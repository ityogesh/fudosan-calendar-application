import 'package:flutter/material.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'otp_screen.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                'パスワードを再設定するための認証コードを送信\nしますので、ご登録いただいているメールアドレスを\nご入力の上「信送」ボタンをクリックしてください。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelText: 'メールアドレス',
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
                  '信送',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                onPressed: () {
                  print('Hi');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OtpScreen()));
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
}
