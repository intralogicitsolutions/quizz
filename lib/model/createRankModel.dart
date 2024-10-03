class CreateRankModel {
  int? status;
  String? message;
  Data? data;

  CreateRankModel({this.status, this.message, this.data});

  CreateRankModel.fromJson(Map<String, dynamic> json) {
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
  String? scoreId;
  String? examId;
  int? score;
  String? sId;
  int? iV;

  Data({this.scoreId, this.examId, this.score, this.sId, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    scoreId = json['score_id'];
    examId = json['exam_id'];
    score = json['score'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score_id'] = this.scoreId;
    data['exam_id'] = this.examId;
    data['score'] = this.score;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}