import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/snackBar.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';  // For jsonEncode

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String?_currentPassword;
  String? _newPassword;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500,),),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            // color: Colors.blue,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        titleSpacing: 00.0,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: Themer.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  _currentPassword = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
                onChanged: (value) {
                  _newPassword = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Themer.buttonColor,
                ),
                onPressed: _resetPassword,
                child: const Text('Reset Password',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // Make the API call
      try {
        String? token = await TokenStorage.getToken();
        final response = await http.post(

          Uri.parse('https://quizz-app-backend-3ywc.onrender.com/auth/reset_password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer $token"
          },

          body: jsonEncode({
            'password': _currentPassword,
            'newPassword': _newPassword?.isNotEmpty == true ? _newPassword : '', // Empty newPassword for verification only
          }),
        );
        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          CustomSnackbar.show(context, responseBody['message']);
          //Navigator.pop(context);
          if (_newPassword?.isNotEmpty == true) {
            Navigator.pop(context);
          }
        } else {
          // Handle error response
          CustomSnackbar.show(context, 'Error: ${responseBody['message']}');
        }
      } catch (e) {
        CustomSnackbar.show(context, 'Error occurred. Please try again.');
      }
    }
  }
}
