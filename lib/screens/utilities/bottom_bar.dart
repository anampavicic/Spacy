import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final String leftButtonName;
  final Icon middleButtonIcon;
  final String rightButtonName;
  final void Function() leftButtonPressed;
  final void Function() middleButtonPressed;
  final void Function() rightButtonPressed;

  /*final String themeId;
  final GlobalKey<FormState> formKey;
  final String name;
  final DateTime? deadline;
  final Function(BuildContext, String) onBackButtonPressed;
  final Function(BuildContext, String, List<dynamic>) onNextButtonPressed;*/

  const CustomBottomAppBar(
      {required this.leftButtonName,
      required this.middleButtonIcon,
      required this.rightButtonName,
      required this.leftButtonPressed,
      required this.middleButtonPressed,
      required this.rightButtonPressed});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              onPressed: () {
                leftButtonPressed();
              },
              child: Text(
                leftButtonName,
                style: TextStyle(color: Colors.white),
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
                  middleButtonPressed();
                },
                iconSize: 50.0,
                icon: middleButtonIcon,
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
              onPressed: () {
                rightButtonPressed();
              },
              child: Text(
                rightButtonName,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
