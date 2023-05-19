import 'package:flutter/material.dart';

class ThemeButtonList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() getThemes;

  ThemeButtonList({required this.getThemes});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getThemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          print(snapshot.hasError);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final themes = snapshot.data;
        if (themes != null && themes.isNotEmpty) {
          return ListView.builder(
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final theme = themes[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Perform actions when the button is pressed
                  },
                  child: Text(theme['name']),
                ),
              );
            },
          );
        }

        return Center(
          child: Text('No themes found.'),
        );
      },
    );
  }
}