class RegisterOtpRequestModel {
  String email;
  String emailOtp;

  RegisterOtpRequestModel({this.email, this.emailOtp});

  RegisterOtpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailOtp = json['email_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['email_otp'] = this.emailOtp;
    return data;
  }
}
