
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_fairy/res/components/colors.dart';

class DayButton extends StatefulWidget {
  final String day;
  final bool isSelected;
  final Function(bool) onTap;

  const DayButton({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _DayButtonState createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  void _handleTap() {
    setState(() {
      _isSelected = !_isSelected;
      widget.onTap(_isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: 23,
        width: 22,
        decoration: BoxDecoration(
          color: _isSelected ? AppColor.primaryColor : AppColor.secondaryBgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _isSelected ?  AppColor.blackColor:  AppColor.blackColor,width: 0.5),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Center(
          child: Text(
            widget.day,
            style: TextStyle(
              fontSize: 14,
              color: _isSelected ? Colors.white : Colors.black,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
