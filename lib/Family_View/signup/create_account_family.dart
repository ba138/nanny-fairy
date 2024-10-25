import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_auth_controller.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../utils/utils.dart';

class CreateAccountFamily extends StatefulWidget {
  const CreateAccountFamily({super.key});

  @override
  State<CreateAccountFamily> createState() => _CreateAccountFamilyState();
}

class _CreateAccountFamilyState extends State<CreateAccountFamily> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController confromPasswordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
    confromPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModelFamily = Provider.of<FamilyAuthController>(context);
    return Scaffold(
        backgroundColor: AppColor.oceanColor,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.west,
                                color: AppColor.authCreamColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 60),
                          Text(
                            'Create Account',
                            style: GoogleFonts.getFont(
                              "Poppins",
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: AppColor.authCreamColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalSpeacing(30),
                      Container(
                        height: 94,
                        width: 94,
                        decoration: BoxDecoration(
                            color: AppColor.avatarColor,
                            borderRadius: BorderRadius.circular(47),
                            border: Border.all(
                                width: 4, color: AppColor.authCreamColor)),
                        child: const Center(
                          child: Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: AppColor.authCreamColor,
                          ),
                        ),
                      ),
                      const VerticalSpeacing(10),
                      Text(
                        'Create Account of\n Your App',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          "Poppins",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.authCreamColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpeacing(16.0),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.authCreamColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 50),
                    child: Column(
                      children: [
                        TextFieldCustom(
                            controller: emailController,
                            prefixIcon: const Icon(Icons.mail_outline),
                            maxLines: 1,
                            hintText: 'Enter Email'),
                        TextFieldCustom(
                            obscureText: true,
                            controller: passwordController,
                            prefixIcon: const Icon(Icons.lock_outline),
                            maxLines: 1,
                            hintText: 'Set A Password'),
                        TextFieldCustom(
                            obscureText: true,
                            controller: confromPasswordController,
                            prefixIcon: const Icon(Icons.lock_outline),
                            maxLines: 1,
                            hintText: 'Confirm Password'),
                        const VerticalSpeacing(30),
                        RoundedButton(
                          title: 'Confirm',
                          onpress: () {
                            if (passwordController.text ==
                                confromPasswordController.text) {
                              authViewModelFamily.createAccount(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                            } else {
                              Utils.toastMessage("Your password did not match");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
