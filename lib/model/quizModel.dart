class QuizModel {
  int? status;
  String? message;
  List<Data>? data;

  QuizModel({this.status, this.message, this.data});

  QuizModel.fromJson(Map<String, dynamic> json) {
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
  String? question;
  List<String>? options;
  int? correctAnswer;
  String? questionId;
  int? iV;

  Data(
      {this.sId,
        this.question,
        this.options,
        this.correctAnswer,
        this.questionId,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    options = json['options'].cast<String>();
    correctAnswer = json['correct_answer'];
    questionId = json['question_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['question'] = this.question;
    data['options'] = this.options;
    data['correct_answer'] = this.correctAnswer;
    data['question_id'] = this.questionId;
    data['__v'] = this.iV;
    return data;
  }
}