import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/models/apiRequestModels/register/registerRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerResponseModel.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_registration.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _myActivity;
  RegisterResponseModel registerResponseModel = new RegisterResponseModel();

  final formKey = new GlobalKey<FormState>();
  final deptKey = new GlobalKey<FormState>();

  final userNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();
  final organizationController = new TextEditingController();
  final departmentNameController = new TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailaddressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmpasswordFocus = FocusNode();
  final FocusNode companynameFocus = FocusNode();
  final FocusNode departmentFocus = FocusNode();

  bool autoValidate = false;
  bool passwordVisibility = true;

  String userName,
      email,
      password,
      confirmPassword,
      companyName,
      department,
      departmentName;

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
      body: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Center(
          child: SingleChildScrollView(
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
                    focusNode: nameFocus,
                    controller: userNameController,
                    decoration: new InputDecoration(
                      labelText: '氏名*',
                    ),
                    validator: (String value) {
                      return ValidateHelper().validateName(value);
                    },
                    onFieldSubmitted: (String value) {
                      _fieldFocusChange(context, nameFocus, emailaddressFocus);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    focusNode: emailaddressFocus,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      labelText: 'メールアドレス*',
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
                    height: 5,
                  ),
                  TextFormField(
                    focusNode: passwordFocus,
                    controller: passwordController,
                    obscureText: passwordVisibility,
                    decoration: new InputDecoration(
                      labelText: 'パスワード*',
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
                      _fieldFocusChange(
                          context, passwordFocus, confirmpasswordFocus);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                      focusNode: confirmpasswordFocus,
                      controller: confirmPasswordController,
                      obscureText: passwordVisibility,
                      decoration: new InputDecoration(
                        labelText: 'パスワードの再確認*',
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
                      validator: (value) {
                        // ignore: missing_return
                        if (value != passwordController.text) {
                          return "not match";
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    focusNode: companynameFocus,
                    controller: organizationController,
                    decoration: new InputDecoration(
                      labelText: '会社名*',
                    ),
                    validator: (String value) {
                      return ValidateHelper().validateCompanyName(value);
                    },
                    onFieldSubmitted: (String value) {
                      _fieldFocusChange(
                          context, companynameFocus, departmentFocus);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: deptKey,
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
                    controller: departmentNameController,
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
                        validateCredentials();
                        /*        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OtpRegistrationScreen()));*/
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
    );
  }

  validateCredentials() {
    if (formKey.currentState.validate()) {
      _doUserRegistration();
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  _doUserRegistration() async {
    RegisterRequestModel registerRequestModel;
    userName = userNameController.text;
    email = emailController.text;
    password = passwordController.text;
    confirmPassword = confirmPasswordController.text;
    companyName = organizationController.text;
    department = _myActivity;
    departmentName = departmentNameController.text;

    /*var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };*/
    registerRequestModel = new RegisterRequestModel(
        fullname: userName,
        email: email,
        password: password,
        cPassword: confirmPassword,
        companyName: companyName,
        department: departmentName);

    var response = await http.post(Constants.register_URL,
        body: registerRequestModel.toJson());

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map registerResponse = responseData;
      registerResponseModel = RegisterResponseModel.fromJson(registerResponse);
      print('Register response');
      print(registerResponseModel.toJson());
      print('User id : ${registerResponseModel.userid}');
      print('Token : ${registerResponseModel.success.token}');
      SharedPreferences instance = await SharedPreferences.getInstance();
      instance.setString("email", emailController.text);
      instance.setString("token", registerResponseModel.success.token);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OtpRegistrationScreen()));
    } else {
      print('response error');
      throw Exception();
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode _currentFocus, FocusNode _nextFocus) {
    _currentFocus.unfocus();
    FocusScope.of(context).requestFocus(_nextFocus);
  }
}
