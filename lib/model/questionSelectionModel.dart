class QuestionSelectionModel {
  int? status;
  String? message;
  List<Data>? data;

  QuestionSelectionModel({this.status, this.message, this.data});

  QuestionSelectionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? examName;
  String? languageId;
  String? categoryId;
  String? difficulty;
  int? iV;

  Data(
      {this.sId,
        this.examName,
        this.languageId,
        this.categoryId,
        this.difficulty,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    examName = json['exam_name'];
    languageId = json['language_id'];
    categoryId = json['category_id'];
    difficulty = json['difficulty'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['exam_name'] = this.examName;
    data['language_id'] = this.languageId;
    data['category_id'] = this.categoryId;
    data['difficulty'] = this.difficulty;
    data['__v'] = this.iV;
    return data;
  }
}