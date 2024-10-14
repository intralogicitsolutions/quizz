import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/theme/theme.dart';
import '../global/tokenStorage.dart';
import '../model/languageModel.dart';
import 'categorySelection.dart';
import 'editProfile.dart';

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

      final url = 'https://quizz-app-backend-3ywc.onrender.com/language';
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
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0,left: 20,right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Center(
                    child:  Image(
                      width: 100,
                      height: 100,
                      image: AssetImage('assets/images/quiz_logo1.png'),
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Themer.buttonColor, Themer.textColor],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child:Wrap(
                      children: [
                        // const Icon(Icons.person,color: Themer.textColor,),
                        const SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Ishita Poshiya",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                            const SizedBox(height: 5,),
                            // Text(PbcAppInstance.instance.fullName.isEmpty?'Complete Profile Detail': PbcAppInstance.instance.fullName,
                            //   style: TextStyle(color: Colors.grey,),),
                          ],
                        )
                      ],
                    ),
                  ),


                  const SizedBox(height: 10,),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person,color: Themer.buttonColor,),
              title: const Text(' Edit Profile ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.password,color: Themer.buttonColor,),
              title: const Text(' Reset Password ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile()),
                );
              },
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.450,
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(10),
            //     decoration:  BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //         colors: [Themer.buttonColor, Themer.buttonColor],
            //       ),
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //     ),
            //     child:Wrap(
            //       children: [
            //         // const Icon(Icons.person,color: Themer.textColor,),
            //         //const SizedBox(width: 10,),
            //         Center(child: Text("Logout",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
            //         const SizedBox(height: 5,)
            //       ],
            //     ),
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.logout,color: Themer.buttonColor,),
              title: const Text(' Logout ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              onTap: () {
                // baseWidget.showAlert("Logout", "Are you sure you want to logout?", "Logout", positive: () {
                //   PbcAppInstance.instance.clearLoginSession(baseWidget.context);
                // },negative:() {
                //
                // },negativeBtn: "Cancel");
              },
            ),
          ],
        ),
      ),
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







