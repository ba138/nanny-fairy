import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import '../../res/components/colors.dart';

class LoginOrSignupView extends StatelessWidget {
  const LoginOrSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const VerticalSpeacing(60.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 163,
                          width: 185,
                          child: Center(
                            child: Image.asset('images/splash.png'),
                          ),
                        ),
                        const VerticalSpeacing(12.0),
                        Text(
                          'Welcome to our',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        Text(
                          'Nanny fairy',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
              const VerticalSpeacing(60.0),
              RoundedButton(
                  title: 'Login as family',
                  onpress: () {
                    Navigator.pushNamed(context, RoutesName.loginFamily);
                  }),
              const VerticalSpeacing(20.0),
              RoundedButton(
                  title: 'register as a family',
                  onpress: () {
                    Navigator.pushNamed(
                        context, RoutesName.createAccountFamily);
                  }),
              const VerticalSpeacing(20.0),
              RoundedButton(
                title: 'register as a provider',
                onpress: () {
                  Navigator.pushNamed(context, RoutesName.createAccount);
                },
              ),
              const VerticalSpeacing(20.0),
              RoundedButton(
                  title: 'Login as provider',
                  onpress: () {
                    Navigator.pushNamed(context, RoutesName.loginView);
                  }),
              const VerticalSpeacing(20.0),
            ],
          ),
        ),
      ),
    );
  }
}
