import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class CustomConvexBottomAppBarOneButton extends StatelessWidget {
  final IconData middleIcon;
  final VoidCallback middleButtonPressed;

  const CustomConvexBottomAppBarOneButton({
    required this.middleIcon,
    required this.middleButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      //curveSize: 130,
      style: TabStyle.fixedCircle,
      cornerRadius: 150,
      activeColor: Colors.white70,
      shadowColor: Colors.white,
      elevation: 7,
      backgroundColor: Color(0xFF001125),
      items: [
        TabItem(
          icon: Icon(
            middleIcon,
            color: Color(0xFF001125),
            size: 60.0,
          ),
        )
      ],
      onTap: (int index) {
        middleButtonPressed();
      },
      initialActiveIndex: 0,
    );
  }
}
