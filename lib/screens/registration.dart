import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/models/apiRequestModels/register/registerRequestModel.dart';
import 'package:login_fudosan/models/apiRequestModels/register/registerUpdateRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerErrorResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerUpdateResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/state_list.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/dropdown.dart';

import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_registration.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _myActivity;
  String _myState;
  List statesList;
  RegisterResponseModel registerResponseModel = new RegisterResponseModel();

  final formKey = new GlobalKey<FormState>();
  final deptKey = new GlobalKey<FormState>();
  final statekey = new GlobalKey<FormState>();

  final userNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();
  final stateController = new TextEditingController();
  final departmentNameController = new TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailaddressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmpasswordFocus = FocusNode();
  final FocusNode companynameFocus = FocusNode();
  final FocusNode dropdownFocus = FocusNode();
  final FocusNode departmentFocus = FocusNode();

  bool autoValidate = false;
  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  bool visible = false;
  int state = 0;
  bool readonly = false;

  ProgressDialog _progressDialog;

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
    progressInit();
    progressStyle();
    _getStateList();
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
        automaticallyImplyLeading: false,
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
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '新規ユーザー登録',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: readonly,
                      style: readonly
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(color: Colors.black),
                      focusNode: nameFocus,
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        labelText: '氏名*',
                      ),
                      validator: (String value) {
                        return ValidateHelper().validateName(value);
                      },
                      onFieldSubmitted: (String value) {
                        _fieldFocusChange(
                            context, nameFocus, emailaddressFocus);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      focusNode: emailaddressFocus,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: readonly
                          ? TextInputAction.done
                          : TextInputAction.next,
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
                      readOnly: readonly,
                      style: readonly
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(color: Colors.black),
                      focusNode: passwordFocus,
                      controller: passwordController,
                      obscureText: passwordVisibility,
                      textInputAction: TextInputAction.next,
                      maxLength: 14,
                      decoration: new InputDecoration(
                        counterText: "",
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
                      readOnly: readonly,
                      style: readonly
                          ? TextStyle(color: Colors.grey)
                          : TextStyle(color: Colors.black),
                      focusNode: confirmpasswordFocus,
                      controller: confirmPasswordController,
                      obscureText: confirmPasswordVisibility,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        labelText: 'パスワードの再確認*',
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
                      validator: (
                        String value,
                      ) {
                        return ValidateHelper().validateConfirmPassword(
                            value, passwordController.text);
                      },
                      onFieldSubmitted: (String value) {
                        _fieldFocusChange(
                            context, confirmpasswordFocus, companynameFocus);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Form(
                      key: statekey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(0.0),
                            color: Colors.transparent,
                            child: ButtonTheme(
                              child: DropdownButtonFormField(
                                value: _myStates,
                                hint: Text('Select State'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _myStates = newValue;
                                    _getStateList();
                                    print(_myStates);
                                  });
                                },
                                items: statesLists?.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['stateName']),
                                        value: item['id'].toString(),
                                      );
                                    })?.toList() ??
                                    [],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Form(
                      key: deptKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(0.0),
                            color: Colors.transparent,
                            child: DropDownFormField(
                              enabled: !readonly,
                              titleText: null,
                              hintText: readonly ? _myActivity : '部署名（任意) ',
                              onSaved: (value) {
                                setState(() {
                                  _myActivity = value;
                                });
                              },
                              value: _myActivity,
                              onChanged: (value) {
                                if (value == "その他") {
                                  setState(() {
                                    _myActivity = value;
                                    visible = true; // !visible;
                                  });
                                } else {
                                  setState(() {
                                    _myActivity = value;
                                    visible = false;
                                  });
                                }
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
                    Visibility(
                      visible: visible,
                      child: TextFormField(
                          readOnly: readonly,
                          style: readonly
                              ? TextStyle(color: Colors.grey)
                              : TextStyle(color: Colors.black),
                          controller: departmentNameController,
                          decoration: new InputDecoration(
                            labelText: '部署名（任意）',
                          ),
                          onFieldSubmitted: (String value) {
                            validateCredentials();
                          }),
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

  validateCredentials() async {
    if (formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
      if (state == 0) {
        await _progressDialog.show();
        _doUserRegistration();
      } else {
        ProgressDialog pd = ProgressDialog(context);
        await _progressDialog.show();
        _doUserRegisatrationUpdate();
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  StatesList states; // = StateList();
  List statesLists;
  String _myStates;
  Future<String> _getStateList() async {
    await http.post(Constants.stateInfoUrl).then((response) {
      states = StatesList.fromJson(json.decode(response.body));
      //  var data = json.decode(response.body);
//      final Map responseValue = data;
//      states = StateList.fromJson(responseValue);
      print(states.toJson());
    });
  }

  _doUserRegisatrationUpdate() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    RegisterUpdateRequestModel registerUpdateRequestModel =
        RegisterUpdateRequestModel(
      email: emailController.text,
      id: instance.getString("id"),
    );
    var response = await http.post(Constants.register_Update_URL,
        body: registerUpdateRequestModel.toJson());
    if (response.statusCode == 200) {
      RegisterUpdateResponseModel registerUpdateResponseModel =
          RegisterUpdateResponseModel.fromJson(json.decode(response.body));
      instance.setString("email", registerUpdateResponseModel.email);
      _progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  OtpRegistrationScreen(emailController.text)));
    } else {
      _progressDialog.hide();
      RegisterErrorResponseModel registerErrorResponseModel =
          RegisterErrorResponseModel.fromJson(json.decode(response.body));
      if (registerErrorResponseModel.error.email[0] ==
          "The email has already been taken.") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "メールはすでに登録されています。",
        );
      }
    }
  }

  _doUserRegistration() async {
    RegisterRequestModel registerRequestModel;
    userName = userNameController.text;
    email = emailController.text;
    password = passwordController.text;
    confirmPassword = confirmPasswordController.text;
//    companyName = organizationController.text;
    department = _myActivity;
    departmentName =
        _myActivity == "その他" ? departmentNameController.text : _myActivity;
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
      SharedPreferences instance = await SharedPreferences.getInstance();
      instance.setString("email", emailController.text);
      instance.setString("token", registerResponseModel.success.token);
      instance.setString("id", registerResponseModel.userid.toString());
      instance.setInt("status", registerResponseModel.success.status);
      setState(() {
        state = 1;
        readonly = true;
      });
      _progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OtpRegistrationScreen(email)));
    } else {
      _progressDialog.hide();
      var error = json.decode(response.body);
      final Map responseError = error;
      RegisterErrorResponseModel registerErrorResponseModel =
          RegisterErrorResponseModel.fromJson(responseError);
      if (registerErrorResponseModel.error.email[0] ==
          "The email has already been taken.") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "メールはすでに登録されています。",
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
