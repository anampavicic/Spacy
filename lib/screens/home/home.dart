import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/theme.dart';
import 'package:spacy/services/database.dart';
import 'package:spacy/screens/home/ThemeButtonList.dart';

import '../theme/AddTheme.dart';

/*class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spacy'),
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            ElevatedButton(
              onPressed: () => _auth.signOut(),
              child: Text(
                  'sign out'
              ),
            ),
          ]
        )
      )
    );
  }
}*/
class Home extends StatefulWidget {
  final String userId;
  const Home ({super.key, required this.userId});

  //const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final UserService _user = UserService();
  final ThemeService _theme = ThemeService();
  @override
  int _selectedIndex = 0;
  List<String> _words = ['Today', 'Active', 'All'];
  String Id = "Ana"; //delete this when you get the chance


  Future<List<Map<String, dynamic>>> getThemes() async {
    //fetch
    final List<String> userThemes = await _user.getUserThemeById(widget.userId.toString());
    if (_selectedIndex == 1){
      return _theme.getThemesByIdsForToday(userThemes);
    }
    return [];
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ]
            ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _words.map((word) {
              int index = _words.indexOf(word);
              bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: isSelected ? Colors.white : Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            word.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        body: ThemeButtonList(
          getThemes: getThemes,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 168,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.transparent,
                    onPrimary: const Color(0xFF0F2027),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  onPressed: () async {
                    /*var id = await ThemeService().addTheme();
                    setState(() {
                        Id = "id";
                    });
                    print(id);
                    print(widget.userId);*/
                    List<String> themes = await _user.getUserThemeById(widget.userId.toString());
                    var names = await _theme.getThemesByIdsForToday(themes);

                  },
                  child: Text(
                    'Theme',
                    style: TextStyle(color: const Color(0xFF0F2027)),
                  ),
                ),
              ),
              SizedBox(
                width: 74,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0F2027),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddThemePage(userId: widget.userId,)), // Navigate to AddThemePage
                      );
                    },
                    iconSize: 50.0,
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 168,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.transparent,
                    onPrimary: const Color(0xFF0F2027),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  onPressed: () => _auth.signOut(),
                  child: Text(
                    "Ana",
                    style: TextStyle(color: const Color(0xFF0F2027)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }
