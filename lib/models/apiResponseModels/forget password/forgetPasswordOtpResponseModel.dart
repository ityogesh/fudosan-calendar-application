class ForgetPasswordOtpResponseModel {
  String success;
  int userid;

  ForgetPasswordOtpResponseModel({this.success, this.userid});

  ForgetPasswordOtpResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['userid'] = this.userid;
    return data;
  }
  /* String success;

  ForgetPasswordOtpResponseModel({this.success});

  ForgetPasswordOtpResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  } */
}
