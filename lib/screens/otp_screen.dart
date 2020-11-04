import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_fudosan/models/apiRequestModels/forget%20password/foregetPasswordOtpRequestModel.dart';
import 'package:login_fudosan/models/apiRequestModels/forget%20password/forgetPasswordOtpVerifyRequestModel.dart';
import 'package:login_fudosan/models/apiRequestModels/register/resendOtpRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/forget%20password/forgetPasswordOtpResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/resendOtpResponseModel.dart';
import 'package:login_fudosan/screens/forget_password.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homescreen.dart';
import 'dart:convert';

class OtpScreen extends StatefulWidget {
  final String email;
  final int uid;
  OtpScreen(this.email, this.uid);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController pin = TextEditingController();
  TextEditingController createPassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool createPasswordVisibility = true;
  bool confirmPasswordVisibility = true;
  FocusNode pinCodeFoucs = FocusNode();
  FocusNode createPasswordFocus = FocusNode();
  FocusNode confrimPasswordFocus = FocusNode();
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
                    builder: (BuildContext context) => ResetPassword()));
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                        "${widget.email}に届いた認証コード及び\n 新しいパスワードを入力し、「パスワードを\n 再設定する」ボタンをクリックしてください。",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    PinCodeTextField(
                      controller: pin,
                      textInputAction: TextInputAction.next,
                      focusNode: pinCodeFoucs,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      onSubmitted: (val) {
                        _fieldFocusChange(
                            context, pinCodeFoucs, createPasswordFocus);
                      },
                      onChanged: (val) {},
                      onCompleted: (val) {
                        _fieldFocusChange(
                            context, pinCodeFoucs, createPasswordFocus);
                      },
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
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      obscureText: createPasswordVisibility,
                      textInputAction: TextInputAction.next,
                      focusNode: createPasswordFocus,
                      maxLength: 14,
                      controller: createPassword,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        counterText: "",
                        labelText: '新しいパスワード',
                        suffixIcon: IconButton(
                            icon: createPasswordVisibility
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                createPasswordVisibility =
                                    !createPasswordVisibility;
                              });
                            }),
                      ),
                      validator: (String value) {
                        return ValidateHelper().validatePassword(value);
                      },
                      onFieldSubmitted: (String value) {
                        _fieldFocusChange(
                            context, createPasswordFocus, confrimPasswordFocus);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: confirmPasswordVisibility,
                      textInputAction: TextInputAction.done,
                      focusNode: confrimPasswordFocus,
                      controller: confirmpassword,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        labelText: '新しいパスワード(確認)',
                        suffixIcon: IconButton(
                            icon: confirmPasswordVisibility
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                confirmPasswordVisibility =
                                    !confirmPasswordVisibility;
                              });
                            }),
                      ),
                      validator: (String value) {
                        return ValidateHelper().validateConfirmPassword(
                            value, createPassword.text);
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
                          'パスワードを再設定する',
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('認証コードは届いていない場合?'),
                        SizedBox(width: 5),
                        InkWell(
                          child: InkWell(
                            onTap: progress,
                            child: Text(
                              '再送信',
                              style: TextStyle(color: ColorConstant.otpButton),
                            ),
                          ),
                        ),
                      ],
                    ),
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
      if (ValidateHelper().validatePin(pin.text)) {
        await _progressDialog.show();
        passwordChange();
      } else {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG, msg: "認証コード入力は必須項目なので入力してください。");
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  progress() async {
    await _progressDialog.show();
    _reSendOtp();
  }

  passwordChange() async {
    ForgetPasswordOtpVerifyRequestModel forgetPasswordOtpVerifyRequestModel =
        ForgetPasswordOtpVerifyRequestModel(
            email: widget.email,
            emailOtp: pin.text,
            password: createPassword.text);

    final body = <String, dynamic>{};
    body.addAll(forgetPasswordOtpVerifyRequestModel.toJson());

    var response =
        await http.post(Constants.forgot_password_Change_URL, body: body);
    if (response.statusCode == 200) {
      ForgetPasswordOtpResponseModel forgetPasswordOtpResponseModel =
          ForgetPasswordOtpResponseModel.fromJson(json.decode(response.body));
      print(response.body);
      _progressDialog.hide();
      showSuccessAlert(context);
    } else {
      _progressDialog.hide();
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: "認証コードは一致しませんのでもう一度試してください。",
      );
      /*  throw Exception('http.post error: statusCode= ${response.statusCode}'); */
    }
    print(response.body);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode _currentFocus, FocusNode _nextFocus) {
    _currentFocus.unfocus();
    FocusScope.of(context).requestFocus(_nextFocus);
  }

  showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here

          child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 9000,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/Success_popup.png"),
                SizedBox(
                  height: 10,
                ),
                Text('パスワードを更新いたしました。'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: ColorConstant.otpButton,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
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

  ResendOtpResponseModel resendOtpRegisterResponseModel =
      ResendOtpResponseModel();

  _reSendOtp() async {
    print('hi');
    ResendOtpRequestModel resendOtpRequestModel;
    SharedPreferences instance = await SharedPreferences.getInstance();

    /*var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };*/
    resendOtpRequestModel = new ResendOtpRequestModel(
      id: widget.uid.toString(),
    );
    var response = await http.post(Constants.register_Resend_Otp_URL,
        body: resendOtpRequestModel.toJson());

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map registerResponse = responseData;
      resendOtpRegisterResponseModel =
          ResendOtpResponseModel.fromJson(registerResponse);
      print(resendOtpRegisterResponseModel.success);
      _progressDialog.hide();
      if (responseData['success'] == "OTP resented successfully") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "認証コードは正常に再送信されました。",
        );
      }
    } else {
      print('response error');
      throw Exception();
    }
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
