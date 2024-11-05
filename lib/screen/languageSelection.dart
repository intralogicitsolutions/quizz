import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/component/drawer.dart';
import 'package:quiz/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/theme/theme.dart';
import '../component/snackBar.dart';
import '../global/tokenStorage.dart';
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
  List<Data> _languages = [];
  LanguageModel? languageModel;

  @override
  void initState() {
    super.initState();
    // Call the language fetch after login completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLanguages();
    });
  }

  Future<void> fetchLanguages() async {
    try {
      String? token = await TokenStorage.getToken();

      if (token == null) {
        print('Token is null');
        return;
      }

      final url = Global.BASE_URL + 'language';
      print("Global token :: ${Global.token}");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        languageModel = LanguageModel.fromJson(jsonDecode(response.body));
        if (mounted) {
          setState(() {
            _languages = languageModel?.data ?? [];
            _selectedLanguageId = _languages.isNotEmpty ? _languages[0].sId : null;
            _selectedLanguage = _languages.isNotEmpty ? _languages[0].name : null;
            _isLoading = false;
          });
        }
      } else {
        print('Failed to load languages');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _callLogoutApi(context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _callLogoutApi(BuildContext context) async {
    String? token = await TokenStorage.getToken();
    final String url = Global.BASE_URL + 'auth/logout'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      },
    );

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      CustomSnackbar.show(context, 'Logout successful');
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      CustomSnackbar.show(context, 'Error: ${responseData['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Languages'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60.2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: Themer.buttonColor,
       // automaticallyImplyLeading: false,
      ),
      drawer: CustomDrawer.show(context),

        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Themer.selectColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Themer.buttonColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedLanguage ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.check_circle,
                      color: Themer.buttonColor),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
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
                  final language = _languages[index];
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
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset('assets/icon/${language.icon}',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,

                        ),

                        title: Text(language.name ?? ''),
                        trailing: Radio<String>(
                          value: language.name ?? '',
                          groupValue: _selectedLanguage,
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value;
                              _selectedLanguageId = language.sId;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Themer.buttonColor,
                      Themer.button2TextColor
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelectionPage(
                                languageId: _selectedLanguageId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Themer.buttonColor,
                    ),
                    child: Text(
                      'Continue'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),

    );
  }
}







