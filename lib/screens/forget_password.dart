import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_fudosan/models/apiRequestModels/forget%20password/foregetPasswordOtpRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/forget%20password/ForgetPasswordOtpResponseModel.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'otp_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailaddress = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    progressInit();
    progressStyle();
  }

  progressInit() {
    _progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
  }

  progressStyle() {
    _progressDialog.style(
      message: Constants.progress_msg,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

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
                    builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: formKey,
          autovalidate: autoValidate,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        "パスワードを再設定するための認証コードを送信\n しますので、ご登録いただいているメールアドレスを\n ご入力の上「送信」ボタンをクリックしてください。",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailaddress,
                      textInputAction: TextInputAction.done,
                      decoration: new InputDecoration(
                        labelText: 'メールアドレス',
                      ),
                      validator: (String value) {
                        return ValidateHelper().validateEmail(value);
                      },
                      onFieldSubmitted: (String value) {
                        checkValidation();
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          '送信',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: ColorConstant.otpButton,
                        onPressed: () {
                          checkValidation();
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
          ),
        ),
      ),
    );
  }

  checkValidation() async {
    if (formKey.currentState.validate()) {
      await _progressDialog.show();
      sendOTP();
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  sendOTP() async {
  //  print("Sending OTP");
    ForgetPasswordOtpRequestModel forgetPasswordOtpRequestModel =
        ForgetPasswordOtpRequestModel(email: emailaddress.text);
    var response = await http.post(Constants.forgot_password_Otp_URL,
        body: forgetPasswordOtpRequestModel.toJson());
    if (response.statusCode == 200) {
      Map sendOtpResponse = json.decode(response.body);
      ForgetPasswordOtpResponseModel forgetPasswordOtpResponseModel =
          ForgetPasswordOtpResponseModel.fromJson(sendOtpResponse);
    //  print('${response.body}');
      _progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OtpScreen(
                  emailaddress.text, forgetPasswordOtpResponseModel.userid)));
    } else {
      _progressDialog.hide();
     // print("Error ${response.body}");
      var error = json.decode(response.body);
      if (error['error'] == "User not found") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "ユーザーが見つかりません。",
        );
      }
      //throw Exception('http.post error: statusCode= ${response.statusCode}');
    }
  }
}
