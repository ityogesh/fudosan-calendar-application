class ForgetPasswordOtpVerifyResponseModel {
  String success;
  PasswordResetStatus passwordResetStatus;

  ForgetPasswordOtpVerifyResponseModel(
      {this.success, this.passwordResetStatus});

  ForgetPasswordOtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    passwordResetStatus = json['password reset status'] != null
        ? new PasswordResetStatus.fromJson(json['password reset status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.passwordResetStatus != null) {
      data['password reset status'] = this.passwordResetStatus.toJson();
    }
    return data;
  }
}

class PasswordResetStatus {
  int id;
  String fullname;
  String email;
  int status;
  String companyName;
  String department;
  String createdAt;
  String updatedAt;

  PasswordResetStatus(
      {this.id,
      this.fullname,
      this.email,
      this.status,
      this.companyName,
      this.department,
      this.createdAt,
      this.updatedAt});

  PasswordResetStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    status = json['status'];
    companyName = json['company_name'];
    department = json['department'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['status'] = this.status;
    data['company_name'] = this.companyName;
    data['department'] = this.department;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
