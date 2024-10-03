// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:quiz/model/createRankModel.dart';
// import 'package:quiz/theme/theme.dart';
// import 'package:http/http.dart' as http;
// import '../global/global.dart';
// import '../model/rankModel.dart';
//
// class RankPage extends StatefulWidget {
//   final String? examId;
//   final double? scorePercentage;
//   final String? scoreId;
//   const RankPage({super.key, this.examId, this.scorePercentage, this.scoreId});
//
//   @override
//   State<RankPage> createState() => _RankPageState();
// }
//
// class _RankPageState extends State<RankPage> {
//   RankModel? rankModel;
//   CreateRankModel? createRankModel;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchRankData();
//   }
//
//   Future<void> fetchRankData() async {
//     String? userId = Global.userId;
//     if (userId == null) {
//       print('User ID is not available');
//       return;
//     }
//     createRankModel= await storeRank(widget.scoreId, widget.examId, widget.scorePercentage);
//     if (createRankModel?.data?.sId == null) {
//       print('Failed to get score_id from storeRank response');
//       return;
//     }
//
//     String scoreId = createRankModel!.data!.sId!;
//     final url = 'https://quizz-app-backend-3ywc.onrender.com/rank_detail?exam_id=${widget.examId}&score_id=$scoreId';
//
//     try {
//       final response = await http.get(Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': "Bearer ${Global.token}"
//         },
//       );
//       print("url is==> $url");
//
//       if (response.statusCode == 200) {
//         // Parse the JSON and update the state
//         setState(() {
//           rankModel = RankModel.fromJson(json.decode(response.body));
//           isLoading = false; // Data has been loaded
//         });
//       } else {
//         setState(() {
//           isLoading = false;  // Stop loading even if there's an error
//         });
//         // Handle non-200 status codes (errors)
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;  // Stop loading on error
//       });
//       print('Error fetching data: $e');
//     }
//   }
//
//   Future<CreateRankModel?> storeRank(String? scoreId, String? examId, double? score) async {
//     final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/rank_detail'; // Your POST API endpoint
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': "Bearer ${Global.token}"
//         },
//         body: json.encode({
//           'user_id': scoreId,
//           'exam_id': examId,
//           'score': score,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         print('Score rank successfully: ${response.body}');
//         return CreateRankModel.fromJson(json.decode(response.body));
//       } else {
//         print('Failed to rank score: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error storing rank: $e');
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rank'),
//         leading: IconButton(
//           icon: SvgPicture.asset(
//             "assets/images/ios-back-arrow.svg",
//             colorFilter: ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: false,
//         //backgroundColor: Colors.deepPurple,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : rankModel != null
//           ? buildRankContent(rankModel!)
//           : Center(child: Text('Failed to load data')),
//     );
//   }
//   Widget buildRankContent(RankModel rankModel) {
//   //  final userRank = rankModel.data?.first.rank ?? 'Unknown';  // Get user's rank
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               Image.asset("assets/images/winnercup2.png"),
//               Positioned(
//                 top: 135,
//                 left: 130,
//                 child: Text(
//                   'Rank 1', // Display the fetched rank
//                   style: TextStyle(fontSize: 20, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 30),
//
//           // Congratulatory text
//           Text(
//             'Congratulations, you\'ve completed this quiz!',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           // Subtext
//           Text(
//             'Let\'s keep honing your knowledge by playing more quizzes!',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }
//






import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/model/createRankModel.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../model/rankModel.dart';

class RankPage extends StatefulWidget {
  final String? examId;
  final double? scorePercentage;
  final String? scoreId;
  const RankPage({super.key, this.examId, this.scorePercentage, this.scoreId});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  RankModel? rankModel;
  CreateRankModel? createRankModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRankData();
  }

  Future<void> fetchRankData() async {
    String? userId = Global.userId;
    if (userId == null) {
      print('User ID is not available');
      return;
    }

    // Step 1: Call the storeRank (POST request) to get score_id
    createRankModel = await storeRank(widget.scoreId, widget.examId, widget.scorePercentage);

    if (createRankModel?.data?.sId == null) {
      print('Failed to get score_id from storeRank response');
      return;
    }

    // Step 2: Use score_id from the POST request to call the GET request
    String scoreId = createRankModel!.data!.sId!;
    final url = 'https://quizz-app-backend-3ywc.onrender.com/rank_detail?exam_id=${widget.examId}&score_id=$scoreId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${Global.token}",
        },
      );
      print("GET request URL: $url");

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

  // Step 1: POST request to store the rank
  Future<CreateRankModel?> storeRank(String? scoreId, String? examId, double? score) async {
    if (scoreId == null || scoreId.isEmpty) {
      print('Error: scoreId is required but it is null or empty.');
      return null;
    }

    final String apiUrl = 'https://quizz-app-backend-3ywc.onrender.com/rank_detail'; // Your POST API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${Global.token}",
        },
        body: json.encode({
          'score_id': scoreId,
          'exam_id': examId,
          'score': score,
        }),
      );

      if (response.statusCode == 200) {
        print('Score rank successfully: ${response.body}');
        return CreateRankModel.fromJson(json.decode(response.body));
      } else {
        print('Failed to rank score: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error storing rank: $e');
    }
    return null;
  }

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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : rankModel != null
          ? buildRankContent(rankModel!)
          : Center(child: Text('Failed to load data')),
    );
  }

  Widget buildRankContent(RankModel rankModel) {
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
                  'Rank ${rankModel.data?.rank ?? 'Unknown'}', // Display the fetched rank
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Congratulations, you\'ve completed this quiz!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
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
