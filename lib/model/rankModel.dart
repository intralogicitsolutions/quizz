// class RankModel {
//   int? status;
//   String? message;
//   List<Data>? data;
//
//   RankModel({this.status, this.message, this.data});
//
//   RankModel.fromJson(Map<String, dynamic> json) {
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
//   String? userId;
//   String? examId;
//   int? score;
//   int? iV;
//   int? rank;
//
//   Data({this.sId, this.userId, this.examId, this.score, this.iV, this.rank});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     userId = json['user_id'];
//     examId = json['exam_id'];
//     score = json['score'];
//     iV = json['__v'];
//     rank = json['rank'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['user_id'] = this.userId;
//     data['exam_id'] = this.examId;
//     data['score'] = this.score;
//     data['__v'] = this.iV;
//     data['rank'] = this.rank;
//     return data;
//   }
// }

class RankModel {
  int? status;
  String? message;
  Data? data;

  RankModel({this.status, this.message, this.data});

  RankModel.fromJson(Map<String, dynamic> json) {
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
  int? rank;

  Data({this.scoreId, this.examId, this.score, this.rank});

  Data.fromJson(Map<String, dynamic> json) {
    scoreId = json['score_id'];
    examId = json['exam_id'];
    score = json['score'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score_id'] = this.scoreId;
    data['exam_id'] = this.examId;
    data['score'] = this.score;
    data['rank'] = this.rank;
    return data;
  }
}