import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/screen/questionSelection.dart';
import 'package:quiz/theme/theme.dart';
import 'package:http/http.dart' as http;

import '../global/global.dart';
import '../model/categoryModel.dart';

class CategorySelectionPage extends StatefulWidget {
  final String? languageId;
  const CategorySelectionPage({super.key,  this.languageId});

  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  String? _selectedCategoryId;
  String _selectedCategory = '';
  //List<Map<String, dynamic>> _categories = [];
 List<Data> _categories = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategory();
  }

  Future<void> fetchCategory() async{
    Global.get("category", {}).then((response) {
      //final data = jsonDecode(response.body);
      final jsonResponse = jsonDecode(response.body);
      CategoryModel categoryModel = CategoryModel.fromJson(jsonResponse);
      setState(() {
        // _languages = List<String>.from(
        //     data['data'].map((lang) => lang['name'])); // Extract language names

        // _categories = categoryModel.data ?? [];
       // _categories = categoryModel.data ?? [];
        _categories = (jsonResponse['data'] as List).map((item) => Data.fromJson(item)).toList();

        // _categories = List<Map<String, dynamic>>.from(data['data'].map((category) => {
        //   'icon': category['icon'],
        //   'label': category['name'],
        // }));
        isLoading = false;
      });
    }).catchError((error) {
      print('Error: $error');
    });


    //
    // final url = "https://quizz-app-backend-3ywc.onrender.com/category";
    // try{
    //   final response = await http.get(Uri.parse(url),
    //       headers: {'Content-Type': 'application/json',
    //         "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzA2Nzc3MiwiZXhwIjoxNzI3MDk2NTcyfQ.RHEZqv09mMTeivLoZQXPbocg09BF8Jtl0RwdwIggqAY"
    //       });
    //       if (response.statusCode == 200) {
    //         // final data = jsonDecode(response.body);
    //         CategoryModel categoryModel = CategoryModel.fromJson(jsonResponse(response.body));
    //         setState(() {
    //           _categories = List<Map<String, dynamic>>.from(data['data'].map((category) => {
    //             'icon': category['icon'],
    //             'label': category['name'],
    //           }));
    //           isLoading = false;
    //         });
    //       }
    //       else{
    //         throw Exception('Failed to load categories');
    //       }
    // }catch(e){
    //   print('Error: $e');
    // }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'music_note':
        return Icons.music_note;
      case 'public':
        return Icons.public;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'calculate':
        return Icons.calculate;
      case 'movie':
        return Icons.movie;
      case 'info':
        return Icons.info;
      case 'science':
        return Icons.science;
      case 'food_bank':
        return Icons.food_bank;
      case 'history':
        return Icons.history;
      default:
        return Icons.help; // Fallback icon if the icon name is not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('category'.toUpperCase(),
          style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w400,),),
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/ios-back-arrow.svg",
            // color: Colors.blue,
            colorFilter: ColorFilter.mode(Themer.buttonColor, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading? Center(child: CircularProgressIndicator())
          :Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category.name ?? "";
                        _selectedCategoryId = category.sId;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedCategory == category.name
                            ? Colors.orange[200]  // Selected color
                            : Themer.button3TextColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            // category['icon'],
                            _getIconData(category.icon ?? 'default_icon'),
                            size: 40,
                            color: Colors.purple[800],
                          ),
                          SizedBox(height: 8),
                          Text(
                            category.name ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedCategory.isEmpty
                    ? null // Disable button if no category selected
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuestionSelection(
                      languageId: widget.languageId,
                      categoryId: _selectedCategoryId,
                      categoryName: _selectedCategory,
                    )),
                  );
                  // Handle quiz start logic
                  print('Start Quiz with $_selectedCategory');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Themer.buttonColor,
                ),
                child: Text(
                  'Continue'.toUpperCase(),
                  style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w500,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}