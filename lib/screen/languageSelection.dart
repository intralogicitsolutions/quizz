import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/theme/theme.dart';
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
        print('response2 ===> ${response.body}');
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
        toolbarHeight: 60.2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: Themer.buttonColor,
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







// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:quiz/global/global.dart';
// import 'package:http/http.dart' as http;
// import 'package:quiz/theme/theme.dart';
// import '../global/tokenStorage.dart';
// import '../model/languageModel.dart';
// import 'categorySelection.dart';
//
// class LanguageSelectionPage extends StatefulWidget {
//   const LanguageSelectionPage({super.key});
//
//   @override
//   _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
// }
//
// class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
//   String? _selectedLanguage = 'English';
//   String? _selectedLanguageId;
//   bool _isLoading = true;
//   List<String> _languages = [];
//   LanguageModel? languageModel;
//
//   @override
//   void initState() {
//     super.initState();
//     // Call the language fetch after login completes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchLanguages();
//     });
//   }
//
//   Future<void> fetchLanguages() async {
//     // setState(() {
//     //   _isLoading = true; // Show loading spinner
//     // });
//     // try {
//     //   final response = await Global.get("language", {});
//     //   if (!mounted) return;
//     //
//     //   languageModel = LanguageModel.fromJson(jsonDecode(response.body));
//     //   setState(() {
//     //     _languages = languageModel?.data?.map((lang) => lang.name!).toList() ?? [];
//     //     _selectedLanguageId = languageModel?.data?.first.sId;
//     //     _selectedLanguage = _languages.isNotEmpty ? _languages[0] : null; // Set first language as default
//     //     _isLoading = false;
//     //   });
//     // } catch (error) {
//     //   if (!mounted) return;
//     //   setState(() {
//     //     _isLoading = false; // Stop loading
//     //   });
//     //   // Display error message
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //       SnackBar(content: Text('Failed to load languages. Please try again.'))
//     //   );
//     // }
//
//     try {
//       String? token = await TokenStorage.getToken();
//
//       if (token == null) {
//         print('Token is null');
//         return;
//       }
//
//       final url = 'https://quizz-app-backend-3ywc.onrender.com/language';
//       print(" globle token :: ${Global.token}");
//       final response = await http.get(Uri.parse(url),
//         headers: {'Content-Type': 'application/json',
//           "Authorization": "Bearer $token"
//         },
//       );
//       if (response.statusCode == 200) {
//         //final data = jsonDecode(response.body);
//         if (!mounted) return;
//         languageModel = LanguageModel.fromJson(jsonDecode(response.body));
//         print('response2 ===> ${response.body}');
//         if(mounted){
//         setState(() {
//           _languages = languageModel?.data?.map((lang) => lang.name!).toList() ?? [];
//               _selectedLanguageId = languageModel?.data?.first.sId;
//               _selectedLanguage = _languages.isNotEmpty ? _languages[0] : null; // Set first language as default
//               _isLoading = false;
//           // _languages = List<String>.from(data['data'].map((lang) => lang['name'])); // Extract language names
//           // _selectedLanguage = _languages.isNotEmpty ? _languages[0] : null; // Set the first language as default
//           // _isLoading = false;
//         });
//         }
//       } else {
//         print('Failed to load languages');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           'Languages'.toUpperCase(),
//           style: const TextStyle(
//             color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         toolbarHeight: 60.2,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               bottomRight: Radius.circular(25),
//               bottomLeft: Radius.circular(25)),
//         ),
//         backgroundColor: Themer.buttonColor,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Selected Language',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Themer.selectColor,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.language, color: Themer.buttonColor),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       _selectedLanguage ?? '',
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   const Icon(Icons.check_circle,
//                       color: Themer.buttonColor),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               'All Languages',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _languages.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 5,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         leading: const Icon(Icons.language),
//                         title: Text(_languages[index]),
//                         trailing: Radio<String>(
//                           value: _languages[index],
//                           groupValue: _selectedLanguage,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedLanguage = value;
//                               _selectedLanguageId = languageModel?.data
//                                   ?.firstWhere((lang) => lang.name == value)
//                                   .sId; // Get the corresponding ID
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   gradient: const LinearGradient(
//                     colors: [
//                       Themer.buttonColor,
//                       Themer.button2TextColor
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CategorySelectionPage(
//                               languageId: _selectedLanguageId)),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     backgroundColor: Themer.buttonColor,
//                   ),
//                   child: Text(
//                     'Continue'.toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'dart:convert';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:quiz/global/global.dart';
// // import 'package:quiz/theme/theme.dart';
// // import '../model/languageModel.dart';
// // import 'categorySelection.dart';
// //
// // class LanguageSelectionPage extends StatefulWidget {
// //   const LanguageSelectionPage({super.key});
// //
// //   @override
// //   _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
// // }
// //
// // class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
// //   String? _selectedLanguage = 'English';
// //   String? _selectedLanguageId;
// //   bool _isLoading = true;
// //   List<String> _languages = [];
// //   LanguageModel? languageModel;
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     fetchLanguages();
// //   }
// //
// //   Future<void> fetchLanguages() async {
// //     try {
// //       final response = await Global.get("language", {});
// //       if (!mounted) return;
// //
// //       languageModel = LanguageModel.fromJson(jsonDecode(response.body));
// //       setState(() {
// //         _languages = languageModel!.data?.map((lang) => lang.name!).toList() ?? [];
// //         _selectedLanguageId = languageModel!.data?.first.sId;
// //         _selectedLanguage = _languages.isNotEmpty ? _languages[0] : null; // Set the first language as default
// //         _isLoading = false;
// //       });
// //     } catch (error) {
// //       if (!mounted) return; // Check again in case of error
// //       print('Error: $error');
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         title: Text(
// //           'Languages'.toUpperCase(),
// //           style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500,),
// //         ),
// //         centerTitle: true,
// //         titleSpacing: 00.0,
// //         toolbarHeight: 60.2,
// //         toolbarOpacity: 0.8,
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.only(
// //               bottomRight: Radius.circular(25),
// //               bottomLeft: Radius.circular(25)),
// //         ),
// //         backgroundColor: Themer.buttonColor,
// //
// //       ),
// //       body: _isLoading ? const Center(child: CircularProgressIndicator()) :Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Selected Language Section
// //             const Text(
// //               'Selected Language',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Container(
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Themer.selectColor,
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.language, color: Themer.buttonColor),
// //                   SizedBox(width: 10),
// //                   Expanded(
// //                     child: Text(
// //                       _selectedLanguage??'',
// //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
// //                     ),
// //                   ),
// //                   Icon(Icons.check_circle, color: Themer.buttonColor),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 30),
// //
// //             // All Languages Section
// //             Text(
// //               'All Languages',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: _languages.length,
// //                 itemBuilder: (context, index) {
// //                   return Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,  // Background color for the list item
// //                         borderRadius: BorderRadius.circular(20),  // Rounded corners
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),  // Soft shadow
// //                             blurRadius: 5,
// //                             offset: Offset(0, 5),  // Offset shadow
// //                           ),
// //                         ],
// //                       ),
// //                       child: ListTile(
// //                         leading: Icon(Icons.language),
// //                         title: Text(_languages[index]),
// //                         trailing: Radio<String>(
// //                           value: _languages[index],
// //                           groupValue: _selectedLanguage,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               _selectedLanguage = value;
// //                               _selectedLanguageId = languageModel!.data?.firstWhere((lang) => lang.name == value).sId; // Get the corresponding ID
// //                             });
// //                           },
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //
// //             // Save Settings Button
// //             SizedBox(
// //               width: double.infinity,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(30),
// //                   gradient: const LinearGradient(
// //                     colors: [
// //                       Themer.buttonColor, // First color in the gradient
// //                         Themer.button2TextColor// Second color in the gradient
// //                     ],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: SizedBox(
// //                   width: double.infinity,
// //                   height: 50,
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       // Save settings logic
// //                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                       //   content: Text('Language saved as $_selectedLanguage'),
// //                       // ));
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) =>CategorySelectionPage(languageId: _selectedLanguageId)),
// //                       );
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                      // padding: EdgeInsets.symmetric(vertical: 16,),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                       backgroundColor: Themer.buttonColor,
// //                       shadowColor: Colors.transparent,
// //                     ),
// //                     child: Text(
// //                       'Continue'.toUpperCase(),
// //                       style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500,),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }