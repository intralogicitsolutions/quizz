class ExamRersultModel {
  String? message;
  String? userId;
  String? examId;
  int? score;
  int? rank;
  List<Result>? result;

  ExamRersultModel(
      {this.message,
        this.userId,
        this.examId,
        this.score,
        this.rank,
        this.result});

  ExamRersultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['user_id'];
    examId = json['exam_id'];
    score = json['score'];
    rank = json['rank'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['exam_id'] = this.examId;
    data['score'] = this.score;
    data['rank'] = this.rank;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? userAnswer;
  String? question;
  List<String>? options;
  int? correctAnswer;

  Result({this.userAnswer, this.question, this.options, this.correctAnswer});

  Result.fromJson(Map<String, dynamic> json) {
    userAnswer = json['user_answer'];
    question = json['question'];
    options = json['options'].cast<String>();
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_answer'] = this.userAnswer;
    data['question'] = this.question;
    data['options'] = this.options;
    data['correct_answer'] = this.correctAnswer;
    return data;
  }
}