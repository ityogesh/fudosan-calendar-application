class RegisterResponseModel {
  int userid;
  Success success;

  RegisterResponseModel({this.userid, this.success});

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    if (this.success != null) {
      data['success'] = this.success.toJson();
    }
    return data;
  }
}

class Success {
  String token;
  String fullname;
  String companyName;
  String stateList;
  int status;
  String department;

  Success(
      {this.token,
      this.fullname,
      this.companyName,
      this.stateList,
      this.status,
      this.department});

  Success.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    fullname = json['fullname'];
    companyName = json['company_name'];
    stateList = json['state_list'];
    status = json['status'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['fullname'] = this.fullname;
    data['company_name'] = this.companyName;
    data['state_list'] = this.stateList;
    data['status'] = this.status;
    data['department'] = this.department;
    return data;
  }
}
