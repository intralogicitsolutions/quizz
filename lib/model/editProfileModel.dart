class EditProfileModel {
  int? status;
  String? message;
  Data? data;

  EditProfileModel({this.status, this.message, this.data});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? firstName;
  String? lastName;
  String? emailId;
  String? password;
  int? iV;
  Null? resetToken;
  Null? resetTokenExpires;

  Data(
      {this.sId,
        this.firstName,
        this.lastName,
        this.emailId,
        this.password,
        this.iV,
        this.resetToken,
        this.resetTokenExpires});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailId = json['email_id'];
    password = json['password'];
    iV = json['__v'];
    resetToken = json['reset_token'];
    resetTokenExpires = json['reset_token_expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_id'] = this.emailId;
    data['password'] = this.password;
    data['__v'] = this.iV;
    data['reset_token'] = this.resetToken;
    data['reset_token_expires'] = this.resetTokenExpires;
    return data;
  }
}