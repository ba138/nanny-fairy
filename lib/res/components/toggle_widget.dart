import 'package:flutter/material.dart';

import 'colors.dart';

class ToggleWidget extends StatefulWidget {
  const ToggleWidget({super.key, required this.title});
  final String title;
  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColor.blackColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              switchValue = !switchValue;
            });
          },
          child: Container(
            width: 40.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color:
              switchValue ? AppColor.primaryColor : const Color(0xffECECEC),
            ),
            child: Row(
              mainAxisAlignment:
              switchValue ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  width: 12.0,
                  height: 12.0,
                  decoration: const BoxDecoration(

                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}