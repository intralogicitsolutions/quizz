import 'dart:convert';
import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    Global.get("language", {}).then((response) {
       languageModel = LanguageModel.fromJson(jsonDecode(response.body));
      setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Languages'.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500,),
          ),
        ),
        centerTitle: false,
        titleSpacing: 00.0,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(0)),
        ),
        backgroundColor: Themer.buttonColor,

      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Language Section
            const Text(
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
                  gradient: const LinearGradient(
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