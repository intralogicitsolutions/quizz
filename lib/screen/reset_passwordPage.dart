import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/snackBar.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../theme/theme.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String? _currentPassword;
  String? _newPassword;
  String? _confirmPassword;
  bool _isCurrentPasswordValid = false;
  bool _isLoading = false; // New variable for loader state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        backgroundColor: Themer.buttonColor,
      ),
      body: Stack(
        children: [
          Padding(
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
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
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
                    enabled: _isCurrentPasswordValid,
                    validator: (value) {
                      if (_isCurrentPasswordValid) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
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
                    enabled: _isCurrentPasswordValid,
                    validator: (value) {
                      if (_isCurrentPasswordValid) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPassword) {
                          return 'Passwords do not match';
                        }
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
                    onPressed: _isCurrentPasswordValid
                        ? _resetPassword
                        : _validateCurrentPassword,
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
            //  color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _validateCurrentPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String? token = await TokenStorage.getToken();
      final response = await http.post(
        Uri.parse(
            Global.BASE_URL + 'auth/reset_password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token"
        },
        body: jsonEncode({
          'password': _currentPassword,
          'newPassword': ""
        }),
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          _isCurrentPasswordValid = true;
        });
        CustomSnackbar.show(context, 'Current password is valid. Enter a new password.');
      } else {
        setState(() {
          _isCurrentPasswordValid = false;
        });
        CustomSnackbar.show(context, 'Invalid current password');
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_isCurrentPasswordValid && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String? token = await TokenStorage.getToken();
        final response = await http.post(
          Uri.parse(
              Global.BASE_URL + 'auth/reset_password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer $token"
          },
          body: jsonEncode({
            'password': _currentPassword,
            'newPassword': _newPassword,
          }),
        );
        final responseBody = jsonDecode(response.body);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          CustomSnackbar.show(context, responseBody['message']);
          Navigator.pop(context);
        } else {
          CustomSnackbar.show(context, 'Error: ${responseBody['message']}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        CustomSnackbar.show(context, 'Error occurred. Please try again.');
      }
    }
  }
}


