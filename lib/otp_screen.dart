import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_fudosan/forget_password.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    builder: (BuildContext context) => ResetPassword()));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                'hep****@gmail.comに届いた確認コード及び \n新しいパスワードを入力し、「新しいパスワードを\n再設定する」ボタンをクリックしてください',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            PinCodeTextField(
              appContext: context,
              length: 4,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              onChanged: (val) {},
              onCompleted: (val) {},
              textStyle: TextStyle(fontSize: 20, color: Colors.white),
              enableActiveFill: true,
              pinTheme: PinTheme(
                  borderRadius: BorderRadius.circular(10.0),
                  selectedFillColor: Colors.grey[300],
                  selectedColor: Colors.grey[300],
                  inactiveFillColor: Colors.grey[300],
                  inactiveColor: Colors.grey[300],
                  activeColor: Colors.orange,
                  fieldWidth: 50.0,
                  activeFillColor: Colors.orange,
                  shape: PinCodeFieldShape.box),
            ),

            /* OTPTextField(
              length: 4,
              fieldWidth: 60.0,
              width: MediaQuery.of(context).size.width,
              style: TextStyle(fontSize: 20, color: Colors.black),
              textFieldAlignment: MainAxisAlignment.spaceEvenly,
              fieldStyle: FieldStyle.box,
              onCompleted: (pin) {
                print("Completed: " + pin);
//              userOTP = pin;
              },
            ),*/
            SizedBox(
              height: 12,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelText: '新しいパスワード',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelText: '新しいパスワード（確認）',
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
                  'パスワードを再設定する',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                onPressed: () {
                  showPalmUploadAlert(context);
                  print('Hi');
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (BuildContext context) => GuideScreen()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
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
            height: 180,
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
                Image.asset("assets/images/right.PNG"),
                SizedBox(
                  height: 10,
                ),
                Text('パスワードを変更いたしました。'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 35,
                  child: RaisedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                    onPressed: () => Navigator.pop(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

/*_showDialog(context) {
  Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: dialogContent(context),
  );
}

Widget dialogContent(BuildContext context) {
  return Center(
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

//              blurRadius: 500.0,

//             offset: Offset(6.6, 7.8),
          ),
        ]),
    child: Column(
      children: [
        Image.asset("assets/images/right.PNG"),
        SizedBox(
          height: 10,
        ),
        Text('パスワードを変更いたしました。'),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: RaisedButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.blue,
            onPressed: () => Navigator.pop(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ],
    ),
  ));
}
*/
/*onAlertDialog(context) {
  Alert(
      context: context,
//      title: "",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/right.PNG"),
          Text('パスワードを変更いたしました。')
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}*/
