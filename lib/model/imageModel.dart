class ImageModel {
  String? message;
  Data? data;

  ImageModel({this.message, this.data});

  ImageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? filename;
  String? path;
  String? originalName;

  Data({this.sId, this.filename, this.path, this.originalName});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    filename = json['filename'];
    path = json['path'];
    originalName = json['originalName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['filename'] = this.filename;
    data['path'] = this.path;
    data['originalName'] = this.originalName;
    return data;
  }
}