import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../model/rankModel.dart';

class RankPage extends StatefulWidget {
  final String? examId;
  final double? scorePercentage;
  const RankPage({super.key, this.examId, this.scorePercentage});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  RankModel? rankModel;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRankData();
  }

  Future<void> fetchRankData() async {
    String? userId = Global.userId;
    if (userId == null) {
      print('User ID is not available');
      return;
    }
    // await storeScore(userId, widget.examId, widget.scorePercentage);
    final url = 'https://quizz-app-backend-3ywc.onrender.com/score_detail?exam_id=${widget.examId}&user_id=$userId';

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
          rankModel = RankModel.fromJson(json.decode(response.body));
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

  // Future<void> storeScore(String userId, String? examId, double? score) async {
  //   final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/score_detail'; // Your POST API endpoint
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzY4NTgyNywiZXhwIjoxNzI3NzE0NjI3fQ.q82TfmMWK8DNunv6k3TAg8Cq9ALL_Fjxfhf9Ij7T8Xw"
  //       },
  //       body: json.encode({
  //         'user_id': userId,
  //         'exam_id': examId,
  //         'score': score,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Score stored successfully: ${response.body}');
  //     } else {
  //       print('Failed to store score: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error storing score: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rank'),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        //backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : rankModel != null
          ? buildRankContent(rankModel!)
          : Center(child: Text('Failed to load data')),
    );
  }
  Widget buildRankContent(RankModel rankModel) {
  //  final userRank = rankModel.data?.first.rank ?? 'Unknown';  // Get user's rank
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset("assets/images/winnercup2.png"),
              Positioned(
                top: 135,
                left: 130,
                child: Text(
                  'Rank 1', // Display the fetched rank
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Congratulatory text
          Text(
            'Congratulations, you\'ve completed this quiz!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),

          // Subtext
          Text(
            'Let\'s keep honing your knowledge by playing more quizzes!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}


//post api request

// {
// "user_id" : "66e967a3a01d561c96a59478",
// "exam_id" : "66f5031879938155964ef390",
// "score" : 95
// }

//POST API RESPONSE
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

//GET API RESPONSE
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
