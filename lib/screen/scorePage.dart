import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz/model/createExamResultModel.dart';
import 'package:quiz/model/scoreModel.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/screen/rankPage.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../model/examResultModel.dart';

class ScorePage extends StatefulWidget {
  final int? totalQuestions;
  final int? correctAnswers;
  final int? wrongAnswers;
  final double? scorePercentage;
  final List<int?>? selectedAnswer;
  final List<int>? correctAnswersList;
  final String? categoryName;
  final String? examId;
  final List<String>? questionId;
  final List<int?>? userAnswer;


  const ScorePage({super.key, this.totalQuestions, this.correctAnswers, this.wrongAnswers,
    this.scorePercentage, this.selectedAnswer, this.correctAnswersList, this.categoryName,
    this.examId, this.questionId, this.userAnswer});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  ScoreModel? scoreModel;
  //bool isLoading = true;
  String? scoreId;
  String? userId = Global.userId;
  int? rank;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchScoreData();
    getExamResult();
  }

  Future<ExamRersultModel?> getExamResult() async {

    await collectUserResponsesAndSubmit();
    final url = Uri.parse(
        'https://quizz-app-backend-3ywc.onrender.com/exam_result?user_id=$userId&exam_id=${widget.examId}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${Global.token}"
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('response:: of get api :: ${response.body}');
        setState(() {
          rank = responseData['rank']; // Save the rank in the state
        });
        print("Rank ::::: $rank");
        return ExamRersultModel.fromJson(responseData);
      } else {
        print('Failed to get exam result: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching exam result: $e');
      return null;
    }
  }


  Future<CreateExamRersultModel?> submitExamResult(
      String? userId, String? examId, double? score, List<Map<String, dynamic>> resultList) async {
    final url = Uri.parse('https://quizz-app-backend-3ywc.onrender.com/exam_result');

    Map<String, dynamic> body = {
      'user_id': userId,
      'exam_id': examId,
      'score': score,
      'result': resultList,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${Global.token}"
        },
        body: json.encode(body),
      );
      print('statuscode=======> ${response.statusCode}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('exam result data response ==> ${responseData}');
        return CreateExamRersultModel.fromJson(responseData);
      } else {
        // Handle server errors
        print('Failed to submit exam result: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while submitting exam result: $e');
      return null;
    }
  }

  Future<bool> updateExamResult(String id, double? score) async {
    final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/exam_result';
    Map<String, dynamic> body = {
      'score': score,
      'user_id': Global.userId,
      'exam_id': widget.examId,
      'result': [
        {
          '_id': id,
          'question_id': widget.questionId,
          'user_answer': widget.userAnswer,
        }
      ]
    };

    try{
      final response = await http.put(
              Uri.parse(apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': "Bearer ${Global.token}"
              },
            body: json.encode(body),
            );
            if (response.statusCode == 200) {
              print('Score update successfully: ${response.body}');
              return true;
            } else {
              print('Failed to update score: ${response.body}');
              return false;
            }
    }catch(e){
      print('Error occurred while updating exam result: $e');
      return false;
    }
  }

  Future<void> collectUserResponsesAndSubmit() async {
    List<Map<String, dynamic>> resultList = [];
    if (widget.questionId != null && widget.userAnswer != null) {
      if (widget.questionId!.length == widget.userAnswer!.length) {
        for (int i = 0; i < widget.questionId!.length; i++) {
          resultList.add({
            'question_id': widget.questionId![i],  // Add question ID
            'user_answer': widget.userAnswer![i]?.toString() ?? '',  // Add user answer
          });
        }
      } else {
        print('Error: questionId and userAnswer lists have different lengths');
      }
    } else {
      print('Error: questionId or userAnswer is null');
    }
    print('resultList: $resultList');
    print('userId: $userId');
    print('examId: ${widget.examId}');
    print('scorePercentage: ${widget.scorePercentage}');

    CreateExamRersultModel? result = await submitExamResult(
      userId,
      widget.examId,
      widget.scorePercentage,
      resultList,
    );

    if (result != null) {
      print('Exam result submitted successfully: ${result.message}');
    } else {
      print('Failed to submit exam result.');
    }
  }


  // Future<void> fetchScoreData() async {
  //   String? userId = Global.userId;
  //   if (userId == null) {
  //     print('User ID is not available');
  //     return;
  //   }
  //
  //  // await storeScore(userId, widget.examId, widget.scorePercentage);
  //   final url = 'https://quizz-app-backend-3ywc.onrender.com/score_detail?exam_id=${widget.examId}&user_id=$userId&score=${widget.scorePercentage}';
  //   try {
  //     final response = await http.get(Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': "Bearer ${Global.token}"
  //       },
  //     );
  //     print("url is==> $url");
  //     print("status code is ===> ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final data = responseData['data'];
  //       //final data1 = json.decode(response.body)['data'];
  //       if (data != null && data.isNotEmpty) {
  //         String existingScoreId = data[0]['_id'];
  //         // Score already exists for this exam and user, update the score
  //         scoreModel = ScoreModel.fromJson(data[0]);
  //         await updateScore(existingScoreId, widget.scorePercentage);
  //         print('data of id is ==> ${existingScoreId}');
  //       } else {
  //         // Score doesn't exist, store a new score
  //         await storeScore(userId, widget.examId, widget.scorePercentage);
  //       }
  //       setState(() {
  //         scoreModel = ScoreModel.fromJson(json.decode(response.body)['data'][0]);
  //         print(response.body);
  //         scoreId = data[0]['_id'];
  //         isLoading = false; // Data has been loaded
  //       });
  //       print('scoreId : ${scoreId}');
  //     } else {
  //       setState(() {
  //         isLoading = false;  // Stop loading even if there's an error
  //       });
  //       // Handle non-200 status codes (errors)
  //       print('Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;  // Stop loading on error
  //     });
  //     print('Error fetching data: $e');
  //   }
  // }

  // Future<void> storeScore(String userId, String? examId, double? score) async {
  //   final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/score_detail';
  //
  //   try {
  //     final response = await http.post(
  //             Uri.parse(apiUrl),
  //             headers: {
  //               'Content-Type': 'application/json',
  //               'Authorization': "Bearer ${Global.token}"
  //             },
  //             body: json.encode({
  //               'user_id': userId,
  //               'exam_id': examId,
  //               'score': score,
  //             }),
  //           );
  //     if (response.statusCode == 200) {
  //             print('Score stored successfully: ${response.body}');
  //           } else {
  //             print('Failed to store score: ${response.body}');
  //           }
  //   }catch(e){
  //     print('Error storing score: $e');
  //   }
  // }

  // Future<void> updateScore(String id, double? score) async{
  //   final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/score_detail?_id=${id}';
  //   try {
  //     final response = await http.put(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': "Bearer ${Global.token}"
  //       },
  //       body: json.encode({
  //         '_id': id,
  //         'score': score,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       print('Score update successfully: ${response.body}');
  //     } else {
  //       print('Failed to update score: ${response.body}');
  //     }
  //   }catch(e){
  //     print('Error updating score: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      backgroundColor: Themer.buttonTextColor,
      body:
      // isLoading
      //   ? Center(child: CircularProgressIndicator())
      // :
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Score Circle
              AvatarGlow(
                glowColor: Colors.purple,
                glowRadiusFactor: 0.09,
                glowCount: 3,
                glowShape: BoxShape.circle,
                curve: Curves.decelerate,
                //endRadius: 120.0,
                duration: Duration(milliseconds: 2000),
                repeat: false,
                animate: true,
                //showTwoGlows: true,
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.25),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Score',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            // '90%',
                            '${widget.scorePercentage?.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Score Details
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('100%', style: TextStyle(color: Colors.purple)),
                            Text('Completion'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('${widget.totalQuestions}', style: TextStyle(color: Colors.purple)),
                            Text('Total Questions'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('${widget.correctAnswers}', style: TextStyle(color: Colors.green)),
                            Text('Correct'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('${widget.wrongAnswers}', style: TextStyle(color: Colors.red)),
                            Text('Wrong'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: <Widget>[
                  buildIconButton(Icons.refresh, 'Play Again', Colors.lightGreen.shade700,
                          () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage(reviewMode: false,
                            categoryName: widget.categoryName,
                            examId: widget.examId,

                          )),
                        );
                        bool isUpdated = await updateExamResult(scoreId!, widget.scorePercentage);
                        if (isUpdated) {
                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Score updated successfully'))
                          );
                        } else {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update score'))
                          );
                        }
                      }
                  ),
                  buildIconButton(Icons.remove_red_eye, 'Review Answer', Colors.orange.shade500,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage(
                            reviewMode: true,
                            selectedAnswers: widget.selectedAnswer,
                            correctAnswers: widget.correctAnswersList,
                            categoryName: widget.categoryName,
                            examId: widget.examId,
                          )),
                        );
                      }
                  ),
                  buildIconButton(Icons.leaderboard, 'Rank', Colors.deepPurple,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RankPage(
                            rank: rank,
                          )),
                        );
                      }
                  ),
                  // buildIconButton(Icons.picture_as_pdf, 'Generate PDF'),
                  // buildIconButton(Icons.home, 'Home'),
                  // buildIconButton(Icons.leaderboard, 'Leaderboard'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom icon button
  Widget buildIconButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: onPressed,
          elevation: 2.0,
          fillColor: color,
          child: Icon(
           icon,
            size: 30.0,
              color: Colors.white
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.black)),
      ],
    );
  }
}


