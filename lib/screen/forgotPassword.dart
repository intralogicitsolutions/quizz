import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/screen/resetPassword.dart';

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
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Success'),
        //     content: Text('Password reset link sent to your email.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
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
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleForgotPassword,
                  child: Text('Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
