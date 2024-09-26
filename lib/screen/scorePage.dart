import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/screen/rankPage.dart';
import 'package:quiz/theme/theme.dart';

class ScorePage extends StatefulWidget {
  final int? totalQuestions;
  final int? correctAnswers;
  final int? wrongAnswers;
  final double? scorePercentage;
  final List<int?>? selectedAnswer;
  final List<int>? correctAnswersList;
  // final String? languageId;
  // final String? categoryId;
  final String? categoryName;
  // final String? difficulty;
  final String? examId;

  const ScorePage({super.key, this.totalQuestions, this.correctAnswers, this.wrongAnswers, this.scorePercentage, this.selectedAnswer, this.correctAnswersList, this.categoryName, this.examId});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      backgroundColor: Themer.buttonTextColor,
      body: Center(
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
                          MaterialPageRoute(builder: (context) => RankPage(examId: widget.examId,)),
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
