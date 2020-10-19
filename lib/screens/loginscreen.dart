import 'dart:convert';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:login_fudosan/models/apiRequestModels/login/loginRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/login/loginResponseModel.dart';
import 'package:login_fudosan/screens/homescreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration.dart';
import 'forget_password.dart';
import 'package:http/http.dart' as http;

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
                style: TextStyle(
                    color: ColorConstant.lButton,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
      body: Form(
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
                      'ようこそ',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 25.0),
                    ),
                    Text('アプリを使用するにはログインしてください。'),
                    SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      focusNode: emailaddressFocus,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        labelText: 'メールアドレス',
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
                        labelText: 'パスワード',
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
                        return ValidateHelper().validatePassword(value);
                      },
                      onFieldSubmitted: (String value) {
                        validateCredentials();
//                        _loginInitiate();
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
                        'パスワードを忘れた方はこちら',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
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
                          'ログイン',
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
    );
  }

  validateCredentials() {
    if (formKey.currentState.validate()) {
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
      print('Login response: ${loginResponseModel.toJson()}');
      print('Token : ${loginResponseModel.success.token}');
      SharedPreferences instance = await SharedPreferences.getInstance();
      instance.setString("token", loginResponseModel.success.token);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreeen()));
    } else
      throw Exception('http.post error: statusCode= ${response.statusCode}');
  }

  _fieldFocusChange(
      BuildContext context, FocusNode _currentFocus, FocusNode _nextFocus) {
    _currentFocus.unfocus();
    FocusScope.of(context).requestFocus(_nextFocus);
  }
}
