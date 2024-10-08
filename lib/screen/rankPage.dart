import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/model/createRankModel.dart';
import 'package:quiz/theme/theme.dart';
import '../model/rankModel.dart';

class RankPage extends StatefulWidget {
  final int? rank;
  const RankPage({super.key, this.rank});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  RankModel? rankModel;
  CreateRankModel? createRankModel;
  // bool isLoading = true;

  @override

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
      body:
      // isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : rankModel != null
      //     ?
      buildRankContent()
          // : Center(child: Text('Failed to load data')),
    );
  }

  Widget buildRankContent() {
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
                  widget.rank != null ? 'Rank ${widget.rank}' : '', // Display the fetched rank
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Congratulations, you\'ve completed this quiz!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
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
