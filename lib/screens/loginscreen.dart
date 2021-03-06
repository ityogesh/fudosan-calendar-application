import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/models/apiRequestModels/login/loginRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/login/loginResponseModel.dart';
import 'package:login_fudosan/screens/homescreen.dart';
import 'package:login_fudosan/screens/otp_registration.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forget_password.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode emailaddressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool autoValidate = false;
  bool passwordVisibility = true;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    checkUserStatus();
    super.initState();
    progressInit();
    progressStyle();
  }

  checkUserStatus() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    if (instance.getString('token') != null) {
      if (instance.getInt('status') == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Show(),
          ),
        );
      } else if (instance.getInt('status') == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                OtpRegistrationScreen(instance.getString('email')),
          ),
        );
      }
    }
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
                '??????????????????',
                style: TextStyle(
                    color: ColorConstant.lButton,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
          )
        ],
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '????????????',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25.0),
                      ),
                      Text(
                        '???????????????????????????????????????????????????????????????',
                        style: TextStyle(color: ColorConstant.lSubtextColor),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        focusNode: emailaddressFocus,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: new InputDecoration(
                          labelText: '?????????????????????',
                          labelStyle:
                              TextStyle(color: ColorConstant.lHintTextColor),
                        ),
                        validator: (String value) {
                          return ValidateHelper().validateEmail(value);
                        },
                        onFieldSubmitted: (String value) {
                          _fieldFocusChange(
                              context, emailaddressFocus, passwordFocus);
                        },
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        focusNode: passwordFocus,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: passwordVisibility,
                        textInputAction: TextInputAction.done,
                        decoration: new InputDecoration(
                          labelText: '???????????????',
                          labelStyle:
                              TextStyle(color: ColorConstant.lHintTextColor),
                          suffixIcon: IconButton(
                              icon: passwordVisibility
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  passwordVisibility = !passwordVisibility;
                                });
                              }),
                        ),
                        validator: (String value) {
                          return ValidateHelper().validateLoginPassword(value);
                        },
                        onFieldSubmitted: (String value) {
                          validateCredentials();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ResetPassword()));
                        },
                        child: Text(
                          '??????????????????????????????????????????',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorConstant.lSubtextColor,
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
                            '????????????',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: ColorConstant.lButton,
                          onPressed: () {
                            validateCredentials();
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
      ),
    );
  }

  validateCredentials() async {
    if (formKey.currentState.validate()) {
      await _progressDialog.show();
      _loginInitiate();
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  _loginInitiate() async {
    LoginRequestModel loginRequestModel = LoginRequestModel(
        email: emailController.text, password: passwordController.text);
    var response =
        await http.post(Constants.login_URL, body: loginRequestModel.toJson());
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map loginResponse = responseData;
      LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(loginResponse);
      SharedPreferences instance = await SharedPreferences.getInstance();
      instance.setString("token", loginResponseModel.success.token);
      instance.setString("email", loginResponseModel.userDetails.email);
      instance.setString("id", loginResponseModel.userDetails.id.toString());
      instance.setInt("status", loginResponseModel.userDetails.status);
      _progressDialog.hide();
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: "????????????????????????????????????",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Show(),
        ),
      );
    } else {
      _progressDialog.hide();
      var error = json.decode(response.body);

      if (error['error'] == "User profile not present") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "??????????????????????????????????????????????????????",
        );
      } else if (error['error'] == "User login password is incorrect") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "?????????????????????????????????????????????????????????????????????",
        );
      } else if (error['error'] == "User not activated") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "?????????????????????????????????????????????????????????",
        );
      }
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode _currentFocus, FocusNode _nextFocus) {
    _currentFocus.unfocus();
    FocusScope.of(context).requestFocus(_nextFocus);
  }
}
