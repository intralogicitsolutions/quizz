import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz/model/createExamResultModel.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/screen/rankPage.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../global/tokenStorage.dart';
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
  //bool isLoading = true;
  String? scoreId;
  String? userId = Global.userId;
  int? rank;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExamResult();
  }

  Future<ExamRersultModel?> getExamResult() async {

    await collectUserResponsesAndSubmit();
    final url = Uri.parse(
        'https://quizz-app-backend-3ywc.onrender.com/exam_result?user_id=$userId&exam_id=${widget.examId}');
    print('getExamResult api url :: $url');
    try {
      String? token = await TokenStorage.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token"
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
    print('submitExamResult api url :: $url');

    Map<String, dynamic> body = {
      'user_id': userId,
      'exam_id': examId,
      'score': score,
      'result': resultList,
    };

    try {
      String? token = await TokenStorage.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token"
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
    const String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/exam_result';
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
      String? token = await TokenStorage.getToken();

      final response = await http.put(
              Uri.parse(apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': "Bearer $token"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Themer.buttonTextColor,
      body:

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
                duration: const Duration(milliseconds: 2000),
                repeat: false,
                animate: true,
                //showTwoGlows: true,
                child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Your Score',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            // '90%',
                            '${widget.scorePercentage?.toStringAsFixed(2) ?? '0.00'}%',
                            style: const TextStyle(
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
              const SizedBox(height: 30),

              // Score Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Column(
                          children: <Widget>[
                            Text('100%', style: TextStyle(color: Colors.purple)),
                            Text('Completion'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('${widget.totalQuestions}', style: TextStyle(color: Colors.purple)),
                            const Text('Total Questions'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('${widget.correctAnswers}', style: TextStyle(color: Colors.green)),
                            const Text('Correct'),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('${widget.wrongAnswers}', style: TextStyle(color: Colors.red)),
                            const Text('Wrong'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

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
                        bool isUpdated = await updateExamResult(scoreId??'', widget.scorePercentage);
                        if (isUpdated) {
                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Score updated successfully'))
                          );
                        } else {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to update score'))
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
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: Icon(
           icon,
            size: 30.0,
              color: Colors.white
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}


