import 'dart:async'; // Import for Timer class
import 'dart:convert';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:quiz/model/quizModel.dart' as quizModel;
import 'package:quiz/screen/scorePage.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;


class QuizPage extends StatefulWidget {
  final bool reviewMode;
  final List<int?>? selectedAnswers;
  final List<int>? correctAnswers;
  final String? categoryName;
  final String? examId;

  const QuizPage({super.key, this.reviewMode = false, this.selectedAnswers, this.correctAnswers, this.categoryName, this.examId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int selectedAnswerIndex = -1;
  List<int?>? selectedAnswers = [];
  Timer? countdownTimer;
  Duration quizDuration = const Duration(minutes: 10); // 30-minute timer
  quizModel.QuizModel? quizData;
  bool? isLoading;
  late ConfettiController confettiController;

  _QuizPageState() : selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = widget.selectedAnswers ?? List<int?>.filled(quizData?.data?.length ?? 10, null); // Initialize with selected answers or default values
    confettiController = ConfettiController(duration: const Duration(seconds: 1));
    if (!widget.reviewMode) {
      startTimer();
    }
    fetchQuizData();
    print('selcet answer====> ${selectedAnswers}');
    //Start the timer when the quiz page loads
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    confettiController.dispose();// Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchQuizData() async {
    final url = "https://quizz-app-backend-3ywc.onrender.com/question/?question_id=${widget.examId}"; // Replace with actual URL
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzM1NjE5OSwiZXhwIjoxNzI3Mzg0OTk5fQ.FVWQRHz5MBpng_NAmufk-tRREgiDa4jtrZrohVZ4sLk"
        },
      );
print("quiz data response ===> ${response.statusCode}");
print("url is==> ${url}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          quizData = quizModel.QuizModel.fromJson(data);
          selectedAnswers = widget.selectedAnswers ??  List.filled(quizData!.data!.length, null); // Initialize with nulls
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Start the countdown timer
  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (quizDuration.inSeconds > 0) {
          quizDuration = quizDuration - Duration(seconds: 1); // Decrease time
        } else {
          timer.cancel();
          if (!widget.reviewMode) {
            _showTimeUpDialog();
          } // Show time-up dialog
        }
      });
    });
  }

  // Show a dialog when the time is up
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Time is up!'),
        content: Text('Your quiz time is over. The quiz will now finish.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform any action when time is up, such as submitting quiz
              finishQuiz();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Display formatted time (MM:SS)
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color getColorForOption(int index, int correctAnswer){
    if(widget.reviewMode){
      if (selectedAnswers![currentQuestionIndex] == index){
        return selectedAnswers![currentQuestionIndex] == correctAnswer
            ? Colors.green.withOpacity(0.7) // Correct answer highlighted in green
            : Colors.red.withOpacity(0.7); // Incorrect answer highlighted in red
      }else if(index == correctAnswer){
         return Colors.green.withOpacity(0.7);

      }
    }
    return Colors.white; // Default background
  }

  Widget getIconForOption(int index, int correctAnswer) {
    if (widget.reviewMode) {
      if (selectedAnswers![currentQuestionIndex] == index) {
        // Selected answer check
        return Icon(
          selectedAnswers![currentQuestionIndex] == correctAnswer
              ? Icons.check_circle
              : Icons.cancel,
          color: selectedAnswers![currentQuestionIndex] == correctAnswer
              ? Colors.green
              : Colors.red,
          size: selectedAnswers![currentQuestionIndex] == correctAnswer
              ? 22
              : 22,
        );
      } else if (index == correctAnswer) {
        // Correct answer check
        return Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 22,
        );
      }
    }
    // Default icon when no selection is made
    return Icon(null); // Or another default color
  }

  // Handle answer selection
  void selectAnswer(int index) {
    if (widget.reviewMode) return;
    setState(() {
      // selectedAnswerIndex = index;
      selectedAnswers![currentQuestionIndex] = index;
      // selectedAnswerIndex = index;
    });
  }

  // Move to the next question
  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < quizData!.data!.length - 1) {
        currentQuestionIndex++;
        if (!widget.reviewMode) {
         // selectedAnswerIndex = -1;
          selectedAnswerIndex = selectedAnswers![currentQuestionIndex] ?? -1;
        }
      } else {
        // Quiz finished logic
        widget.reviewMode ? finishQuizReview()
       : finishQuiz();
      }
    });
  }

  // Move to the previous question
  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        // selectedAnswerIndex = -1; // Reset the answer when going back
        // selectedAnswerIndex = selectedAnswers![currentQuestionIndex] ?? -1;
      }
    });
  }
  int calculateCorrectAnswers(List<quizModel.Data> questions, List<int?> selectedAnswers) {
    int correctCount = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        correctCount++;
      }
    }

    return correctCount;
  }
  void finishQuizReview(){
    int totalQuestions = quizData!.data!.length;
    int correctAnswers = calculateCorrectAnswers(quizData!.data!, selectedAnswers!);
    int wrongAnswers = totalQuestions - correctAnswers;
    double scorePercentage = (correctAnswers / totalQuestions) * 100;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScorePage(
        correctAnswers: correctAnswers,
        scorePercentage: scorePercentage,
        totalQuestions: totalQuestions,
        wrongAnswers: wrongAnswers,
        selectedAnswer: selectedAnswers,
        correctAnswersList: quizData!.data!.map((e) => e.correctAnswer!).toList(),
        categoryName: widget.categoryName,
        examId: widget.examId,
      )),
    );

  }

  // Finish the quiz
  void finishQuiz() {
    int totalQuestions = quizData!.data!.length;
    int correctAnswers = calculateCorrectAnswers(quizData!.data!, selectedAnswers!);
    int wrongAnswers = totalQuestions - correctAnswers;
    double scorePercentage = (correctAnswers / totalQuestions) * 100;
    countdownTimer?.cancel(); // Stop the timer when the quiz finishes
    confettiController.play();
    showDialog(
      context: context,
      builder: (_) => Stack(
        children: [
          ConfettiWidget(
            confettiController: confettiController,
           blastDirection: pi / 2, // Direction of the confetti
            emissionFrequency: 0.2,
            numberOfParticles: 20,
            blastDirectionality: BlastDirectionality.explosive,
            gravity: 0.1,
            colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow], // Custom colors
            child: AlertDialog(
              title: Text('Quiz Completed!'),
              // content: Text('You have finished the quiz.'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('You have finished the quiz.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    confettiController.stop();
                    print('selectd answer is --> ${selectedAnswers}');
                    print('selectd answer from widget --> ${widget.selectedAnswers}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScorePage(
                          correctAnswers: correctAnswers,
                          scorePercentage: scorePercentage,
                          totalQuestions: totalQuestions,
                          wrongAnswers: wrongAnswers,
                          selectedAnswer: selectedAnswers,
                          correctAnswersList: quizData!.data!.map((e) => e.correctAnswer!).toList(),
                          categoryName: widget.categoryName,
                          examId: widget.examId,
                        )),
                      );
                  },
                  child: Text('Finish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   // final int correctAnswer = 0;
    // final question = questions[currentQuestionIndex]['question'] as String;
    // final answers = questions[currentQuestionIndex]['answers'] as List<String>;
    // if (quizData == null || quizData!.data == null || quizData!.data!.isEmpty) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName}'.toUpperCase(),
          style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w400,),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:quizData == null || quizData!.data == null || quizData!.data!.isEmpty
            ? Center(child: CircularProgressIndicator())
            :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // if (!widget.reviewMode)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1}/${quizData!.data!.length}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
                // Display the countdown timer
                if (!widget.reviewMode) ...[
                  Text(
                    formatDuration(quizDuration),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  //const SizedBox(height: 20),
                ],

                // Text(
                //   formatDuration(quizDuration),
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.red,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              //question,
              quizData!.data![currentQuestionIndex].question!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: quizData!.data![currentQuestionIndex].options!.length,
                itemBuilder: (context, index) {
                  int correctAnswerIndex = quizData!.data![currentQuestionIndex].correctAnswer!;
                  return GestureDetector(
                    onTap:
                   // widget.reviewMode ? null :
                        () => selectAnswer(index),
                    //    onTap: () {
                    //      if (widget.reviewMode) {
                    //        selectAnswer(index);
                    //      }
                    //    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        // color: getColorForOption(index, correctAnswerIndex),
                        color: widget.reviewMode
                            ? getColorForOption(index, correctAnswerIndex)
                            :selectedAnswers?[currentQuestionIndex] == index
                        //selectedAnswerIndex == index
                               ? Theme.of(context).primaryColor.withOpacity(0.7)
                               : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.reviewMode
                                ? Colors.white
                                : selectedAnswers?[currentQuestionIndex] == index
                                //selectedAnswerIndex == index
                                    ? Colors.white
                                    : Colors.grey.shade400,
                              ),
                              color: widget.reviewMode
                              ? Colors.white
                              : selectedAnswers?[currentQuestionIndex] == index
                              //selectedAnswerIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            child: widget.reviewMode
                                ? getIconForOption(index, correctAnswerIndex)
                                : selectedAnswers?[currentQuestionIndex] == index
                                  ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                              size: 22,
                            ):null,

                            // selectedAnswers?[currentQuestionIndex] == index
                            // //selectedAnswerIndex == index
                            //     ? widget.reviewMode ? Icon(
                            //   selectedAnswers![currentQuestionIndex] == correctAnswerIndex
                            //       ? Icons.check_circle
                            //       : Icons.cancel,
                            //   color: selectedAnswers![currentQuestionIndex] == correctAnswerIndex
                            //       ? Colors.green
                            //       : Colors.red,
                            //   // Icons.check_circle,
                            //   // color: Theme.of(context).primaryColor,
                            //   // size: 22,
                            // ):Icon(
                            //   Icons.check_circle,
                            //   color: Theme.of(context).primaryColor,
                            //   size: 22,
                            // )
                            //     : null,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                             // answers[index],
                              quizData!.data![currentQuestionIndex].options![index],
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedAnswers?[currentQuestionIndex] == index
                                //selectedAnswerIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (currentQuestionIndex > 0) // Show Previous button after the first question
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: previousQuestion,
                      child: Text(
                        'Previous'.toUpperCase(),
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),
                      ),
                      style: ElevatedButton.styleFrom(
                       // primary: Colors.grey.shade400,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Themer.selectColor,
                      ),
                    ),
                  ),
               // if (!widget.reviewMode)
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed:selectedAnswers?[currentQuestionIndex] == null ? null : nextQuestion,
                    //selectedAnswerIndex == -1 ? null : nextQuestion,
                    child: Text(
                      currentQuestionIndex < quizData!.data!.length - 1 ? 'Next'.toUpperCase() : widget.reviewMode ? 'Done'.toUpperCase(): 'Finish'.toUpperCase(),
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),
                    ),
                    style: ElevatedButton.styleFrom(
                     // primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Themer.selectColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
