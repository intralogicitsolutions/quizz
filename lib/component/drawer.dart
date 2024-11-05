import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz/component/snackBar.dart';
import '../global/global.dart';
import '../global/tokenStorage.dart';
import '../screen/editProfile.dart';
import '../screen/reset_passwordPage.dart';
import '../theme/theme.dart';

class CustomDrawer {

  static Container show(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.75, // Set the width to 75% of the screen width
      child: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75, // Set the width to 75% of the screen width
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            children: [
              Container(
                // Header container with background color
                padding: EdgeInsets.only(top: 50, bottom: 20, left: 30), // Add left padding
                color: Themer.buttonColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                  children: [
                    CircleAvatar(
                      radius: 40, // Large size for the profile image
                      backgroundColor: Colors.white,
                      child: (Global.userImagePath != null && Global.userImagePath!.isNotEmpty)
                          ? ClipOval(
                        child: Image.network(
                          Global.userImagePath!,
                          width: 80, // Match the radius * 2
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(Icons.person, color: Colors.grey, size: 60),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${Global.userFirstName} ${Global.userLastName}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      "${Global.userEmail}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Divider(), // Add a divider line between the header and the list tiles
              ListTile(
                leading: Icon(Icons.person, color: Themer.buttonColor),
                title: const Text(
                  'Update Profile',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.password, color: Themer.buttonColor),
                title: const Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Themer.buttonColor),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _callLogoutApi(context);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

Future<void> _callLogoutApi(BuildContext context) async {
  String? token = await TokenStorage.getToken();
  final String url = Global.BASE_URL + 'auth/logout'; // Replace with your API URL
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    },
  );

  if (!context.mounted) return;

  if (response.statusCode == 200) {
    CustomSnackbar.show(context, 'Logout successful');
  } else {
    final Map<String, dynamic> responseData = json.decode(response.body);
    CustomSnackbar.show(context, 'Error: ${responseData['message']}');
  }
}