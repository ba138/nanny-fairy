import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../res/components/colors.dart';

class Utils {
  static void focusNode(
      BuildContext context, FocusNode current, FocusNode focusNext) {
    current.unfocus();
    FocusScope.of(context).requestFocus(focusNext);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blueAccent.shade100,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        borderRadius: BorderRadius.circular(20.0),
        titleSize: 20.0,
        padding: const EdgeInsets.all(16.0),
        positionOffset: 20,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error,
          color: AppColor.whiteColor,
          size: 30.0,
        ),
      )..show(context),
    );
  }

  static snackBar(String mesg, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Text(
          mesg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
