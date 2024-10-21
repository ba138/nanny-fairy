import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickFrontImg(
  BuildContext context,
) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(
        pickedImage.path,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
  return image;
}

Future<File?> pickBackImg(
  BuildContext context,
) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(
        pickedImage.path,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
  return image;
}
