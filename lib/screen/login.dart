import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quiz/screen/forgotPassword.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../global/tokenStorage.dart';
import 'languageSelection.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.purple.shade200,
            ),
          ),
          Positioned(
            top: 60,
            right: -80,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.purple.shade100,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset("assets/images/quiz_logo1.png", height: 130),
                  const SizedBox(height: 10),
                  LoginForm(isLogin: isLogin),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      }
                    },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign up"
                          : "Already have an account? Login",
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool isLogin;

  const LoginForm({required this.isLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  final String signupUrl = 'https://quizz-app-backend-3ywc.onrender.com/auth/signup';
  final String signinUrl = 'https://quizz-app-backend-3ywc.onrender.com/auth/signin';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {
    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email_id': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (!mounted) return; // Ensure widget is still in the tree

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        );
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Signup Error'),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Error during signup: $e');
    }
  }

  Future<void> handleSignin() async {
    try {
      final response = await http.post(
        Uri.parse(signinUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_id': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200) {
        final userId = responseData['data']['_id'];
        Global.userId = userId; // Set the global user ID

        final token = responseData['data']['access_token'];
        await TokenStorage.saveToken(token);
        print('token :: ${token}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Error during signin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isLogin)
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        if (!widget.isLogin)
          const SizedBox(height: 10),
        if (!widget.isLogin)
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        if (!widget.isLogin)
          const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.lock_open : Icons.lock,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPassword()),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.purple,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (widget.isLogin) {
                handleSignin();
              } else {
                handleSignup();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Themer.selectColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              widget.isLogin ? 'LOGIN' : 'SIGN UP',
              style: const TextStyle(
                color: Themer.Text2Color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
