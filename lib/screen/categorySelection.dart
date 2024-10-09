import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz/screen/questionSelection.dart';
import 'package:quiz/theme/theme.dart';
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
      final jsonResponse = jsonDecode(response.body);
   //  CategoryModel categoryModel = CategoryModel.fromJson(jsonResponse);
      setState(() {
        _categories = (jsonResponse['data'] as List).map((item) => Data.fromJson(item)).toList();
        isLoading = false;
      });
    }).catchError((error) {
      print('Error: $error');
    });
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
      body: isLoading? const Center(child: CircularProgressIndicator())
          :Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            offset: const Offset(0, 3),
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
                          const SizedBox(height: 8),
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
                  style: const TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w500,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}