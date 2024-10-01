import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz/global/global.dart';
import 'package:quiz/theme/theme.dart';
import '../model/languageModel.dart';
import 'categorySelection.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? _selectedLanguage = 'English';
  String? _selectedLanguageId;
  bool _isLoading = true;
  List<String> _languages = [];
  LanguageModel? languageModel;
  // final List<String> _languages = [
  //   'English',
  //   'Hindi',
  //   'Gujarati',
  //   'Marathi',
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    Global.get("language", {}).then((response) {
      //final data = jsonDecode(response.body);
       languageModel = LanguageModel.fromJson(jsonDecode(response.body));
      setState(() {
        // _languages = List<String>.from(
        //     data['data'].map((lang) => lang['name'])); // Extract language names
        _languages = languageModel!.data?.map((lang) => lang.name!).toList() ?? [];
        _selectedLanguageId = languageModel!.data?.first.sId;
        _selectedLanguage = _languages.isNotEmpty
            ? _languages[0]
            : null; // Set the first language as default
        _isLoading = false;
      });
    }).catchError((error) {
      print('Error: $error');
    });
    // final url = 'https://quizz-app-backend-3ywc.onrender.com/language';
    // try {
    //   final response = await http.get(Uri.parse(url),
    //     headers: {'Content-Type': 'application/json',
    //       "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzA2Nzc3MiwiZXhwIjoxNzI3MDk2NTcyfQ.RHEZqv09mMTeivLoZQXPbocg09BF8Jtl0RwdwIggqAY"
    //     },
    //   );
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     print('response2 ===> ${response.body}');
    //     setState(() {
    //       _languages = List<String>.from(data['data'].map((lang) => lang['name'])); // Extract language names
    //       _selectedLanguage = _languages.isNotEmpty ? _languages[0] : null; // Set the first language as default
    //       _isLoading = false;
    //     });
    //   } else {
    //     print('Failed to load languages');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: SvgPicture.asset(
        //     "assets/images/ios-back-arrow.svg",
        //     // color: Colors.blue,
        //     colorFilter: ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Languages'.toUpperCase(),
            style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w400,),
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Language Section
            Text(
              'Selected Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Themer.selectColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.language, color: Themer.buttonColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedLanguage??'',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.check_circle, color: Themer.buttonColor),
                ],
              ),
            ),
            SizedBox(height: 30),

            // All Languages Section
            Text(
              'All Languages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,  // Background color for the list item
                        borderRadius: BorderRadius.circular(20),  // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),  // Soft shadow
                            blurRadius: 5,
                            offset: Offset(0, 5),  // Offset shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons.language),
                        title: Text(_languages[index]),
                        trailing: Radio<String>(
                          value: _languages[index],
                          groupValue: _selectedLanguage,
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value;
                              _selectedLanguageId = languageModel!.data?.firstWhere((lang) => lang.name == value).sId; // Get the corresponding ID
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Save Settings Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Themer.buttonColor, // First color in the gradient
                        Themer.button2TextColor// Second color in the gradient
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save settings logic
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text('Language saved as $_selectedLanguage'),
                      // ));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>CategorySelectionPage(languageId: _selectedLanguageId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                     // padding: EdgeInsets.symmetric(vertical: 16,),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Themer.buttonColor,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Continue'.toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500,),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}