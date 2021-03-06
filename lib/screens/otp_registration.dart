import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_fudosan/models/apiRequestModels/register/registerOtpRequestModel.dart';
import 'package:login_fudosan/models/apiRequestModels/register/resendOtpRequestModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerOtpErrorResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/registerOtpResponseModel.dart';
import 'package:login_fudosan/models/apiResponseModels/register/resendOtpResponseModel.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:login_fudosan/utils/constants.dart';
import 'package:login_fudosan/utils/validateHelper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homescreen.dart';

class OtpRegistrationScreen extends StatefulWidget {
  final String email;

  OtpRegistrationScreen(this.email);

  @override
  _OtpRegistrationScreenState createState() => _OtpRegistrationScreenState();
}

class _OtpRegistrationScreenState extends State<OtpRegistrationScreen> {
  RegisterOtpResponseModel registerOtpResponseModel =
      new RegisterOtpResponseModel();
  final formKey = new GlobalKey<FormState>();

  final otpController = new TextEditingController();

  String email_otp;
  ProgressDialog _progressDialog;
  bool autoValidate = false;

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
            Navigator.pop(context);
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
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        "????????????????????????????????????${widget.email}\n ??????????????????????????????????????????????????????????????????\n ?????????????????????????????????",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PinCodeTextField(
                      controller: otpController,
                      appContext: context,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          '??????',
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
                        Text('???????????????????????????????????????????'),
                        SizedBox(width: 5),
                        InkWell(
                          child: InkWell(
                            onTap: progress,
                            child: Text(
                              '?????????',
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
      if (ValidateHelper().validatePin(otpController.text)) {
        await _progressDialog.show();
        _doUserOtpRegistration();
      } else {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG, msg: "????????????????????????????????????????????????????????????????????????");
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

  _doUserOtpRegistration() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    RegisterOtpRequestModel registerOtpRequestModel;
    email_otp = otpController.text;
    registerOtpRequestModel =
        new RegisterOtpRequestModel(email: widget.email, emailOtp: email_otp);
    var response = await http.post(Constants.register_Otp_URL,
        body: registerOtpRequestModel.toJson());
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map registerOtpResponse = responseData;
      registerOtpResponseModel =
          RegisterOtpResponseModel.fromJson(registerOtpResponse);
      instance.setInt("status", 1);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Show()));
    } else {
      _progressDialog.hide();
      var errorData = json.decode(response.body);
      final Map errorResponse = errorData;
      RegisterOtpErrorResponseModel registerOtpErrorResponseModel =
          RegisterOtpErrorResponseModel.fromJson(errorResponse);
      if (registerOtpErrorResponseModel.error == "OTP verification failed") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "??????????????????????????????????????????????????????????????????????????????",
        );
      }
    }
  }

  ResendOtpResponseModel resendOtpRegisterResponseModel =
      ResendOtpResponseModel();
  String id;

  _reSendOtp() async {
    ResendOtpRequestModel resendOtpRequestModel;
    SharedPreferences instance = await SharedPreferences.getInstance();
    id = instance.getString('id');
    resendOtpRequestModel = new ResendOtpRequestModel(
      id: id,
    );
    var response = await http.post(Constants.register_Resend_Otp_URL,
        body: resendOtpRequestModel.toJson());

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      final Map registerResponse = responseData;
      resendOtpRegisterResponseModel =
          ResendOtpResponseModel.fromJson(registerResponse);
      _progressDialog.hide();
      if (responseData['success'] == "OTP resented successfully") {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "??????????????????????????????????????????????????????",
        );
      }
    } else {
      throw Exception();
    }
  }
}
