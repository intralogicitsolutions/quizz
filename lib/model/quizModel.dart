// class QuizModel {
//   int? status;
//   String? message;
//   List<Data>? data;
//
//   QuizModel({this.status, this.message, this.data});
//
//   QuizModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? question;
//   List<String>? answers;
//   int? correctAnswer;
//   String? languageId;
//   String? categoryId;
//   String? difficulty;
//   int? iV;
//
//   Data(
//       {this.sId,
//         this.question,
//         this.answers,
//         this.correctAnswer,
//         this.languageId,
//         this.categoryId,
//         this.difficulty,
//         this.iV});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     question = json['question'];
//     answers = json['answers'].cast<String>();
//     correctAnswer = json['correctAnswer'];
//     languageId = json['language_id'];
//     categoryId = json['category_id'];
//     difficulty = json['difficulty'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['question'] = this.question;
//     data['answers'] = this.answers;
//     data['correctAnswer'] = this.correctAnswer;
//     data['language_id'] = this.languageId;
//     data['category_id'] = this.categoryId;
//     data['difficulty'] = this.difficulty;
//     data['__v'] = this.iV;
//     return data;
//   }
// }

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