import 'dart:convert';
import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
  File? _image;
  String? _imageFilename;
  bool isPasswordVisible = false;
  bool isLoading = false;

  final String signupUrl = Global.BASE_URL + 'auth/signup';
  final String signinUrl = Global.BASE_URL + 'auth/signin';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Show a dialog to choose between camera and gallery
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final XFile? image = await _picker.pickImage(source: pickedSource);

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    }
  }
  //String imgUrl = "https://quizz-app-backend-3ywc.onrender.com/images/upload";


  Future<void> handleSignup() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      String? imgUrl;
      if (_image != null) {
        // Create a request to upload the image
        var request = http.MultipartRequest(
          'POST',
          // Uri.parse('https://quizz-app-backend-3ywc.onrender.com/images/upload'),
          Uri.parse(Global.BASE_URL + 'images/upload'),
        );
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

        // Send the request

        var response = await request.send();
        var responseData = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          final Map<String, dynamic> imageResponse = jsonDecode(responseData.body);
          imgUrl = imageResponse['data']['img_url']; // Get img_url from the response
          _imageFilename = imageResponse['data']['filename'];
          print('image response :::::::: ${imgUrl} , ${_imageFilename} , ${imageResponse}');
        } else {
          // Handle image upload error
          print('Image upload failed: ${responseData.body}');
          return; // Stop the signup process if image upload fails
        }
      }

      // var request = http.MultipartRequest('POST', Uri.parse(signupUrl));
      // // request.headers['Content-Type'] = 'application/json';
      //
      // request.fields['last_name'] = _lastNameController.text.trim();
      // request.fields['email_id'] = _emailController.text.trim();
      // request.fields['first_name'] = _firstNameController.text.trim();
      // request.fields['password'] = _passwordController.text.trim();
      //
      // if (_image != null) {
      //   request.files.add(await http.MultipartFile.fromPath('image_path', _image!.path));
      // }
      //
      // final response = await request.send();
      //
      // final responseData = await http.Response.fromStream(response);
      // final Map<String, dynamic> responseJson = jsonDecode(responseData.body);
      // String imgUrl = "https://quizz-app-backend-3ywc.onrender.com/images/upload";

      var requestBody = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email_id': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'image_path': imgUrl ?? '',
      };

      // Send the request as JSON
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Handle the response
      final Map<String, dynamic> responseJson = jsonDecode(response.body);


      if (response.statusCode == 200) {
        if (!mounted) return;

        // final userId = responseJson['data']['_id'];
        // final imagePath = responseJson['data']['image_path'];
        //
        // print('Signup successful! User ID: $userId, Image Path: $imagePath');

        await handleSignin(_emailController.text, _passwordController.text);
        print('Signup failed with status ${response.statusCode}: ${response.body}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        );
      } else if (response.statusCode == 400) {
        if (!mounted) return;
        print('Signup failed with status ${response.statusCode}: ${response.body}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Signup Error'),
            content: Text(responseJson['message']),
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
      print('Error during signup: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Future<void> handleSignin(String email, String password) async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      final response = await http.post(
        Uri.parse(signinUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_id': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200) {
        final userId = responseData['data']['_id'];
        Global.userId = userId;
        final userFirstName = responseData['data']['first_name'];
        Global.userFirstName = userFirstName;

        final userLastName = responseData['data']['last_name'];
        Global.userLastName = userLastName;

        final userEmail = responseData['data']['email_id'];
        Global.userEmail = userEmail;

        final userImagePath = responseData['data']['image_path'];
        Global.userImagePath = userImagePath;

        print('image path is ===> ${Global.userImagePath}');

        final token = responseData['data']['access_token'];
        await TokenStorage.saveToken(token);
        Global.token = token;
        print('token :: $token');
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
      print('Error during signin: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (!widget.isLogin) const SizedBox(height: 10),
            if (!widget.isLogin)
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: _image == null
                      ? (_imageFilename == null
                      ? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.grey, size: 40),
                  )
                      : Image.network(
                    Global.BASE_URL + 'images/uploads/$_imageFilename',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ))
                      : ClipOval(
                    child: Image.file(
                      _image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),

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
            if (!widget.isLogin) const SizedBox(height: 10),
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
            if (!widget.isLogin) const SizedBox(height: 10),
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
            if (widget.isLogin)
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
                    handleSignin(_emailController.text, _passwordController.text);
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
                  widget.isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

