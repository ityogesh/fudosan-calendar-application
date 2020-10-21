class RegisterErrorResponseModel {
  Error error;

  RegisterErrorResponseModel({this.error});

  RegisterErrorResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class Error {
  List<String> email;

  Error({this.email});

  Error.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}
