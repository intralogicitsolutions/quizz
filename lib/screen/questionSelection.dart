import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../model/questionSelectionModel.dart';

class QuestionSelection extends StatefulWidget {
  final String? languageId;
  final String? categoryId;
  final String? categoryName;
  const QuestionSelection({super.key, this.languageId, this.categoryId, this.categoryName});

  @override
  _QuestionSelectionState createState() => _QuestionSelectionState();
}

class _QuestionSelectionState extends State<QuestionSelection> {
  int selectedQuestions = 10;
  String selectedDifficulty = 'easy'; // Default difficulty
  QuestionSelectionModel? questionSelectionModel;
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchExamDetails(); // Fetch initial data with default difficulty
  }

  Future<void> _fetchExamDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    // API URL with dynamic difficulty
    final url = "https://quizz-app-backend-3ywc.onrender.com/exam_detail?language_id=${widget.languageId}&category_id=${widget.categoryId}&difficulty=$selectedDifficulty";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzM1NjE5OSwiZXhwIjoxNzI3Mzg0OTk5fQ.FVWQRHz5MBpng_NAmufk-tRREgiDa4jtrZrohVZ4sLk"
        },
      );
      print("quiz data response ===> ${response.statusCode}");
      print("url is==> $url");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          questionSelectionModel = QuestionSelectionModel.fromJson(jsonData);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}'.toUpperCase(),
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Difficulty selection container
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Select Difficulty Level',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDifficultyButton('easy'),
                        _buildDifficultyButton('medium'),
                        _buildDifficultyButton('difficult'),
                      ],
                    ),
                  ],
                ),
              ),

              // Display list of exams
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                    ? Center(child: Text('Error loading exams'))
                    : questionSelectionModel?.data == null || questionSelectionModel!.data!.isEmpty
                    ? Center(child: Text('No exams available'))
                    : ListView.builder(
                  itemCount: questionSelectionModel!.data!.length,
                  itemBuilder: (context, index) {
                    final exam = questionSelectionModel!.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  categoryName: widget.categoryName,
                                  examId: exam.sId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(exam.examName ?? 'Unknown Exam'),
                            ),
                            trailing: Icon(Icons.navigate_next),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String difficulty) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDifficulty = difficulty;
        });
        _fetchExamDetails(); // Fetch the exams with the selected difficulty
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: selectedDifficulty == difficulty ? Themer.buttonColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Themer.buttonColor, width: 2),
        ),
        child: Text(
          //difficulty,
          '${difficulty[0].toUpperCase()}${difficulty.substring(1)}',
          style: TextStyle(
            color: selectedDifficulty == difficulty ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
