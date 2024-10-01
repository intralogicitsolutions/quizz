import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quiz/model/scoreModel.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/screen/rankPage.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';

class ScorePage extends StatefulWidget {
  final int? totalQuestions;
  final int? correctAnswers;
  final int? wrongAnswers;
  final double? scorePercentage;
  final List<int?>? selectedAnswer;
  final List<int>? correctAnswersList;
  final String? categoryName;
  final String? examId;

  const ScorePage({super.key, this.totalQuestions, this.correctAnswers, this.wrongAnswers, this.scorePercentage, this.selectedAnswer, this.correctAnswersList, this.categoryName, this.examId});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  ScoreModel? scoreModel;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchScoreData();
  }

  Future<void> fetchScoreData() async {
    String? userId = Global.userId;
    if (userId == null) {
      print('User ID is not available');
      return;
    }
    await storeScore(userId, widget.examId, widget.scorePercentage);
    final url = 'https://quizz-app-backend-3ywc.onrender.com/score_detail?exam_id=${widget.examId}&user_id=$userId&score=${widget.scorePercentage}';
    try {
      final response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsInJlc2V0X3Rva2VuIjpudWxsLCJyZXNldF90b2tlbl9leHBpcmVzIjpudWxsLCJpYXQiOjE3Mjc3NjIzNTYsImV4cCI6MTcyNzc5MTE1Nn0.B7yKd6xUGCQmpJclYfYV8762mV36e1WnPTUs1ypFuTE"
        },
      );
      print("url is==> $url");

      if (response.statusCode == 200) {
        // Parse the JSON and update the state
        setState(() {
          scoreModel = ScoreModel.fromJson(json.decode(response.body));
          isLoading = false; // Data has been loaded
        });
      } else {
        setState(() {
          isLoading = false;  // Stop loading even if there's an error
        });
        // Handle non-200 status codes (errors)
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;  // Stop loading on error
      });
      print('Error fetching data: $e');
    }
  }

  Future<void> storeScore(String userId, String? examId, double? score) async {
    final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/score_detail';

    try {
      final response = await http.post(
              Uri.parse(apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsInJlc2V0X3Rva2VuIjpudWxsLCJyZXNldF90b2tlbl9leHBpcmVzIjpudWxsLCJpYXQiOjE3Mjc3NjIzNTYsImV4cCI6MTcyNzc5MTE1Nn0.B7yKd6xUGCQmpJclYfYV8762mV36e1WnPTUs1ypFuTE"
              },
              body: json.encode({
                'user_id': userId,
                'exam_id': examId,
                'score': score,
              }),
            );
      if (response.statusCode == 200) {
              print('Score stored successfully: ${response.body}');
            } else {
              print('Failed to store score: ${response.body}');
            }
    }catch(e){
      print('Error storing score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      backgroundColor: Themer.buttonTextColor,
      body: isLoading
        ? Center(child: CircularProgressIndicator())
      : Center(
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
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage(reviewMode: false,
                            // languageId: widget.languageId,
                            // categoryId: widget.categoryId,
                            categoryName: widget.categoryName,
                            // difficulty: widget.difficulty,
                            examId: widget.examId,

                          )),
                        );
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
                            // languageId: widget.languageId,
                            // categoryId: widget.categoryId,
                            categoryName: widget.categoryName,
                            // difficulty: widget.difficulty,
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
                            examId: widget.examId,
                            scorePercentage: widget.scorePercentage,
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
        //Icon(icon, size: 30, color: Themer.Text2Color),
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

//post api response

// {
// "status": 200,
// "message": "Success",
// "data": {
// "user_id": "66e967a3a01d561c96a59478",
// "exam_id": "66f5031879938155964ef390",
// "score": 95,
// "_id": "66fbf4a5d1d7cb915451839c",
// "__v": 0
// }
// }

//post api request
// {
// "user_id" : "66e967a3a01d561c96a59478",
// "exam_id" : "66f5031879938155964ef390",
// "score" : 95
// }

//get api response
// {
// "status": 200,
// "message": "Success",
// "data": [
// {
// "_id": "66fbf4a5d1d7cb915451839c",
// "user_id": "66e967a3a01d561c96a59478",
// "exam_id": "66f5031879938155964ef390",
// "score": 95,
// "__v": 0
// }
// ]
// }