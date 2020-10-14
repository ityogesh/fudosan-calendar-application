class LoginResponseModel {
  Success success;
  UserDetails userDetails;

  LoginResponseModel({this.success, this.userDetails});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
    userDetails = json['UserDetails'] != null
        ? new UserDetails.fromJson(json['UserDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success.toJson();
    }
    if (this.userDetails != null) {
      data['UserDetails'] = this.userDetails.toJson();
    }
    return data;
  }
}

class Success {
  String token;

  Success({this.token});

  Success.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

class UserDetails {
  int id;
  String fullname;
  String email;
  int status;
  String companyName;
  String department;
  String createdAt;
  String updatedAt;

  UserDetails(
      {this.id,
      this.fullname,
      this.email,
      this.status,
      this.companyName,
      this.department,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
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
