import 'package:flutter/material.dart';

import '../colors.dart';

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom(
      {super.key,
      this.hintText,
      required int maxLines,
      this.controller,
      this.keyboardType,
      this.obscureText = false,
      this.validator,
      this.prefixIcon,
      this.shadowColor});

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Color? shadowColor;
  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColor.authCreamColor,
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: widget.shadowColor == null
              ? const Color(0xff1B81BC).withOpacity(0.10)
              : AppColor.lavenderColor
                  .withOpacity(0.1), // Stroke color with 10% opacity
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor == null
                ? const Color(0xff1B81BC).withOpacity(0.1)
                : AppColor.lavenderColor
                    .withOpacity(0.1), // Drop shadow color with 4% opacity
            blurRadius: 2,
            offset: const Offset(1, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        obscureText: (widget.obscureText && hidden),
        style: const TextStyle(fontSize: 15),
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          prefixIconColor: AppColor.oceanColor,
          hintText: widget.hintText,
          filled: false,
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() => hidden = !hidden);
                  },
                  child: Icon(
                    hidden ? Icons.visibility_off : Icons.visibility,
                    color: hidden ? null : AppColor.oceanColor,
                    size: 30,
                  ),
                )
              : null,
          fillColor: const Color(0xffEEEEEE),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfff1f1f1)),
            borderRadius: BorderRadius.zero,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.shadowColor == null
                    ? Color(0xfff1f1f1)
                    : AppColor.creamyColor),
            borderRadius: BorderRadius.zero,
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
