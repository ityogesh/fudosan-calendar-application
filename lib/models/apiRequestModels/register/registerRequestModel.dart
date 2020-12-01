class RegisterRequestModel {
  String fullname;
  String email;
  String password;
  String cPassword;
  String companyName;
  String stateList;
  String department;

  RegisterRequestModel(
      {this.fullname,
      this.email,
      this.password,
      this.cPassword,
      this.companyName,
      this.stateList,
      this.department});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    email = json['email'];
    password = json['password'];
    cPassword = json['c_password'];
    companyName = json['company_name'];
    stateList = json['state_list'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['password'] = this.password;
    data['c_password'] = this.cPassword;
    data['company_name'] = this.companyName;
    data['state_list'] = this.stateList;
    data['department'] = this.department;
    return data;
  }
}
