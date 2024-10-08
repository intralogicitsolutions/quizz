import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/screen/resetPassword.dart';

import '../theme/theme.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final String forgotPasswordUrl = 'https://quizz-app-backend-3ywc.onrender.com/auth/forgotPassword';

  Future<void> handleForgotPassword() async {
    try {
      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email_id': _emailController.text}),
      );

      print('Full Response: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('response ${response.body}');

        final String? resetToken = responseData['resetToken'];
        print('reset token : ${resetToken}');
        if(resetToken != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(token: resetToken),
            ),
          );
        }
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print('Error during password reset: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Forgot Password'.toUpperCase(),
            style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w400,),),
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            // color: Colors.blue,
            colorFilter: const ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleForgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
