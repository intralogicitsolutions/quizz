// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
//
// import '../theme/theme.dart';
// import 'login.dart';
//
// class OtpVerification extends StatefulWidget{
//   final String? email;
//
//   const OtpVerification({super.key,this.email,});
//   @override
//   State<OtpVerification> createState() => _OtpVerificationState();
// }
//
// class _OtpVerificationState extends State<OtpVerification> {
//   final _otpController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final String resetPasswordUrl = 'https://quizz-app-backend-3ywc.onrender.com/auth/resetPassword';
//
//   Future<void> handleResetPassword() async {
//     try {
//       final response = await http.post(
//         Uri.parse(resetPasswordUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email_id': widget.email,
//           'otp': _otpController.text,
//           'new_password': _newPasswordController.text
//         }),
//       );
//
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         // Show success dialog or navigate to a new screen
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Success'),
//             content: const Text('Password reset successfully'),
//             actions: [
//               TextButton(
//                 // onPressed: () => Navigator.pop(context),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) =>const Login()),
//                   );
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       } else {
//         // Handle error
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Error'),
//             content: Text(responseData['message']),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle network or other errors
//       print('Error during password reset: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Reset Password'.toUpperCase(),
//         style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500,),),
//         centerTitle: true,
//         leading: IconButton(
//           icon: SvgPicture.asset(
//             "assets/images/ios-back-arrow.svg",
//             colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 00.0,
//         toolbarHeight: 60.2,
//         toolbarOpacity: 0.8,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               bottomRight: Radius.circular(25),
//               bottomLeft: Radius.circular(25)),
//         ),
//         backgroundColor: Themer.buttonColor,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _otpController,
//                 decoration: InputDecoration(
//                   labelText: 'OTP',
//                   prefixIcon: const Icon(Icons.lock),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _newPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   prefixIcon: Icon(Icons.password),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   prefixIcon: const Icon(Icons.password),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                 ),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20,),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: handleResetPassword,
//                   child: Text('Submit',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Themer.buttonColor,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//           ],),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../theme/theme.dart';
import 'login.dart';

class OtpVerification extends StatefulWidget {
  final String? email;

  const OtpVerification({super.key, this.email});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final String resetPasswordUrl = 'https://quizz-app-backend-3ywc.onrender.com/auth/resetPassword';

  Future<void> handleResetPassword() async {
    // Validate that the new password and confirm password match
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in both password fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      // Show error if passwords don't match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Proceed with the API call if the validation passes
    try {
      final response = await http.post(
        Uri.parse(resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_id': widget.email,
          'otp': _otpController.text,
          'new_password': _newPasswordController.text
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Show success dialog or navigate to a new screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Password reset successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
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
      // Handle network or other errors
      print('Error during password reset: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password'.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0.0,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        backgroundColor: Themer.buttonColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                obscureText: true, // Add this to hide the password
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                obscureText: true, // Add this to hide the password
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleResetPassword,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Themer.buttonColor,
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
