import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                          const SizedBox(
                            height: 10,
                          ),

                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
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
                            height: 40,
                          ),

                          Container(
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
                            child: const Center(
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
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
