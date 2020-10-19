class ForgetPasswordOtpVerifyRequestModel {
  String email;
  String emailOtp;
  String password;

  ForgetPasswordOtpVerifyRequestModel(
      {this.email, this.emailOtp, this.password});

  ForgetPasswordOtpVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailOtp = json['email_otp'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['email_otp'] = this.emailOtp;
    data['password'] = this.password;
    return data;
  }
}
