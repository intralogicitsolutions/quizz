class CreateExamRersultModel {
  String? message;
  Data? data;

  CreateExamRersultModel({this.message, this.data});

  CreateExamRersultModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? examId;
  int? score;
  List<Result>? result;

  Data({this.sId, this.userId, this.examId, this.score, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    examId = json['exam_id'];
    score = json['score'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['exam_id'] = this.examId;
    data['score'] = this.score;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? questionId;
  String? userAnswer;
  String? sId;

  Result({this.questionId, this.userAnswer, this.sId});

  Result.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    userAnswer = json['user_answer'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['user_answer'] = this.userAnswer;
    data['_id'] = this.sId;
    return data;
  }
}