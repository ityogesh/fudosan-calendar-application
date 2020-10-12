import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpRegistrationScreen extends StatefulWidget {
  @override
  _OtpRegistrationScreenState createState() => _OtpRegistrationScreenState();
}

class _OtpRegistrationScreenState extends State<OtpRegistrationScreen> {
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
            /*Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ResetPassword()));*/
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
                '本人確認のため、ご登録のhep****@gmail.comに\n届いた確認コードを入力し、「確認」ボタンを\nクリックしてください',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
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

            /*  OTPTextField(
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
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                child: Text(
                  '確認',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                onPressed: () {
                  showPalmUploadAlert(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('確認コードは届いていない場合?'),
                SizedBox(width: 5),
                InkWell(
                  child: Text(
                    '再送信',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showPalmUploadAlert(BuildContext context) {
    showDialog(
      context: context,
//      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here

          child: Container(
            padding: EdgeInsets.all(15),
            height: 140,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
//              color: Colors.lightBlueAccent,
                    color: Colors.transparent,

                    blurRadius: 5000.0,

//             offset: Offset(6.6, 7.8),
                  ),
                ]),
            child: Column(
              children: [
                Image.asset("assets/images/pop.PNG"),
                SizedBox(
                  height: 10,
                ),
                Text('計算したい日付を選択してください。'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    );
  }
}
