class UserListResponseModel {
  int userid;
  Success success;

  UserListResponseModel({this.userid, this.success});

  UserListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String deviceToken;

  Success({this.deviceToken});

  Success.fromJson(Map<String, dynamic> json) {
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_token'] = this.deviceToken;
    return data;
  }
}
