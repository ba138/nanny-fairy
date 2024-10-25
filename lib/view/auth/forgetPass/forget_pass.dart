import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import '../../../res/components/colors.dart';
import '../../../utils/routes/routes_name.dart';
import '../../../utils/utils.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final FirebaseAuth authInstance = FirebaseAuth.instance;

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Forget Password',
          style: GoogleFonts.getFont(
            "Poppins",
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: AppColor.whiteColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset your password',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(20.0),
                  Text(
                    'we will send a reset password link\nto your email',
                    style: GoogleFonts.getFont(
                      "Poppins",
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColor.grayColor,
                      ),
                    ),
                  ),
                  const VerticalSpeacing(20.0),
                  TextFieldCustom(
                      controller: emailController,
                      maxLines: 1,
                      hintText: 'hasnainDev@gmail.com'),
                  const VerticalSpeacing(16.0),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : RoundedButton(
                          title: 'Send Me Link',
                          onpress: () {
                            _forgetPassFCT();
                          }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _forgetPassFCT() async {
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      Utils.snackBar("Please enter a correct email address", context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: emailController.text.toLowerCase());
        Utils.snackBar("An email has been sent to your email address", context);

        Navigator.pushNamed(context, RoutesName.loginView);
      } on FirebaseException catch (error) {
        Utils.flushBarErrorMessage('${error.message}', context);

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        Utils.flushBarErrorMessage('$error', context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
