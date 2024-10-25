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
  String? imagePath;
  bool? isLoggedOut;
  int? iV;

  Data(
      {this.sId,
        this.firstName,
        this.lastName,
        this.emailId,
        this.password,
        this.imagePath,
        this.isLoggedOut,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailId = json['email_id'];
    password = json['password'];
    imagePath = json['image_path'];
    isLoggedOut = json['isLoggedOut'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_id'] = this.emailId;
    data['password'] = this.password;
    data['image_path'] = this.imagePath;
    data['isLoggedOut'] = this.isLoggedOut;
    data['__v'] = this.iV;
    return data;
  }
}