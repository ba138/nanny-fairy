import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/res/components/loading_manager.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/custom_text_field.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../../utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Providers');

  Future<bool> checkIfUserIsProvider(String id) async {
    final snapshot = await _dbRef.orderByChild('uid').equalTo(id).once();
    return snapshot.snapshot.exists;
  }

  Future<void> _loginProvider() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in the user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? currentUser = userCredential.user;

        if (currentUser != null) {
          final currentId = currentUser.uid;

          // Check if the current user is a provider
          bool isProvider = await checkIfUserIsProvider(currentId);

          if (isProvider) {
            Provider.of<ProviderDistanceViewModel>(context, listen: false)
                .fetchFamiliesFromFirebaseData();
            // If the user is a provider, perform the login function
            final authController =
                Provider.of<AuthViewModel>(context, listen: false);
            authController.loginAccount(
              email: emailController.text,
              password: passwordController.text,
              context: context,
            );
          } else {
            // If the user is not a provider, show a snackbar message
            Utils.snackBar(
              'Your ID does not match, please log in to the family section.',
              context,
            );
          }
        } else {
          Utils.snackBar(
            'Login failed! User could not be authenticated.',
            context,
          );
        }
      } catch (e) {
        // Handle login errors
        Utils.toastMessage(
          "Login Failed! please sigUp first",
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } else {
      Utils.toastMessage(
        "Login Failed! Email and password cannot be empty.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: AppColor.authCreamColor,
      body: LoadingManager(
        isLoading: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
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
                                  color: AppColor.oceanColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  const VerticalSpeacing(30.0),
                  TextFieldCustom(
                      controller: emailController,
                      maxLines: 1,
                      hintText: 'hasnainDev@gmail.com'),
                  TextFieldCustom(
                      obscureText: true,
                      controller: passwordController,
                      maxLines: 1,
                      hintText: '*********'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.forgetPass);
                        },
                        child: Text(
                          'Forget Password?',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpeacing(60.0),
                  RoundedButton(
                    title: 'Login',
                    onpress: _loginProvider,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
