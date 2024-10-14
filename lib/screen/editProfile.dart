import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/screen/languageSelection.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../model/editProfileModel.dart';
import '../model/getUserProfileModel.dart';
import '../theme/theme.dart';

class EditProfile extends StatefulWidget{
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingProfile = true;
  String? userId = Global.userId;


  Future<void> _fetchUserProfile() async {
    String? token = await TokenStorage.getToken();
    String url = 'https://quizz-app-backend-3ywc.onrender.com/auth/profile/?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        GetUserProfileModel getProfileResponse = GetUserProfileModel.fromJson(jsonDecode(response.body));

        // Populate the text fields with the existing user data
        if (getProfileResponse.data != null) {
          setState(() {
            _firstNameController.text = getProfileResponse.data!.firstName ?? '';
            _lastNameController.text = getProfileResponse.data!.lastName ?? '';
            _emailController.text = getProfileResponse.data!.emailId ?? '';
            //_passwordController.text = getProfileResponse.data!.password ?? '';
            _isLoadingProfile = false; // Profile data loaded
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data')),
        );
        setState(() {
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch profile data when the page loads
  }


  Future<void> _editUserProfile() async{
    String? token = await TokenStorage.getToken();
    setState(() {
      _isLoading = true;
    });
    String url = 'https://quizz-app-backend-3ywc.onrender.com/auth/profile/$userId';

    Map<String, dynamic> requestBody = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email_id': _emailController.text,
     // 'password': _passwordController.text,
    };
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        EditProfileModel editProfileResponse = EditProfileModel.fromJson(jsonDecode(response.body));

        if (editProfileResponse.status == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LanguageSelectionPage()),
            );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(editProfileResponse.message ?? 'Failed to update profile')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themer.selectColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 40,
          ),
          Stack(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/quiz_logo1.png",
                  width: 150.0,
                  height: 140.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                height: double.infinity,
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Set radius here
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text("Edit Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20)),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                            ),
                          ),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          //
                          // TextField(
                          //   controller: _passwordController,
                          //   decoration: InputDecoration(
                          //     hintText: "Password",
                          //     hintStyle: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         color: Colors.grey
                          //     ),
                          //   ),
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.normal,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 40,
                          ),

                          GestureDetector(
                            onTap: _editUserProfile,
                            child: Container(
                              height: 50,
                              width: 200,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Themer.buttonColor,
                                    Themer.button3TextColor
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child:  Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
