import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomConvexBottomAppBar extends StatelessWidget {
  final IconData leftIcon;
  final IconData middleIcon;
  final IconData rightIcon;
  final VoidCallback leftButtonPressed;
  final VoidCallback middleButtonPressed;
  final VoidCallback rightButtonPressed;

  const CustomConvexBottomAppBar({
    required this.leftIcon,
    required this.middleIcon,
    required this.rightIcon,
    required this.leftButtonPressed,
    required this.middleButtonPressed,
    required this.rightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      //curveSize: 130,
      style: TabStyle.fixedCircle,
      activeColor: Colors.white70,
      shadowColor: Colors.white,
      elevation: 7,
      backgroundColor: Color(0xFF001125),
      items: [
        TabItem(
          icon: Icon(
            leftIcon,
            color: CupertinoColors.white,
            size: 40.0,
          ),
        ),
        TabItem(
          icon: Icon(
            middleIcon,
            color: Color(0xFF001125),
            size: 60.0,
          ),
        ),
        TabItem(
          icon: Icon(
            rightIcon,
            color: CupertinoColors.white,
            size: 40.0,
          ),
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            leftButtonPressed();
            break;
          case 1:
            middleButtonPressed();
            break;
          case 2:
            rightButtonPressed();
            break;
        }
      },
      initialActiveIndex: 1,
    );
  }
}
