import 'package:flutter/material.dart';
import 'package:nanny_fairy/Family_View/Login/family_login.dart';
import 'package:nanny_fairy/Family_View/Login/forget_password_family.dart';
import 'package:nanny_fairy/Family_View/communityFamily/upload_community_post_family.dart';
import 'package:nanny_fairy/Family_View/familyNotifications/family_notifications.dart';
import 'package:nanny_fairy/Family_View/filters/filter_family_popup.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:nanny_fairy/Family_View/homeFamily/dashboard_family/dashboard_family.dart';
import 'package:nanny_fairy/Family_View/profileFamily/my_profile_family.dart';
import 'package:nanny_fairy/Family_View/settingsFamily/setting_family.dart';
import 'package:nanny_fairy/Family_View/signup/create_account_family.dart';
import 'package:nanny_fairy/Family_View/signup/register_details_family.dart';
import 'package:nanny_fairy/Family_View/signup/select_passion_family.dart';
import 'package:nanny_fairy/Family_View/signup/upload_id_family.dart';
import 'package:nanny_fairy/Family_View/signup/upload_img_family.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/view/auth/forgetPass/forget_pass.dart';
import 'package:nanny_fairy/view/auth/login/login_view.dart';
import 'package:nanny_fairy/view/auth/login_or_signup_view.dart';
import 'package:nanny_fairy/view/auth/signup/availability_view.dart';
import 'package:nanny_fairy/view/auth/signup/create_account.dart';
import 'package:nanny_fairy/view/auth/signup/education_horly_view.dart';
import 'package:nanny_fairy/view/auth/signup/fill_prefrences_view.dart';
import 'package:nanny_fairy/view/auth/signup/register_details.dart';
import 'package:nanny_fairy/view/auth/signup/select_passion_view.dart';
import 'package:nanny_fairy/view/auth/signup/select_preference.dart';
import 'package:nanny_fairy/view/auth/signup/upload_image.dart';
import 'package:nanny_fairy/view/auth/uploadId/upload_id.dart';
import 'package:nanny_fairy/view/booked/booked_view.dart';
import 'package:nanny_fairy/view/community/community_view.dart';
import 'package:nanny_fairy/view/community/upload_comunity_post.dart';
import 'package:nanny_fairy/view/home/dashboard/dashboard.dart';
import 'package:nanny_fairy/view/home/home_view.dart';
import 'package:nanny_fairy/view/notifications/notifications_view.dart';
import 'package:nanny_fairy/view/onboarding/splash_view.dart';
import 'package:nanny_fairy/view/profile/my_profile.dart';
import 'package:nanny_fairy/view/profile/profile_view.dart';
import 'package:nanny_fairy/view/rating/rating.dart';
import 'package:nanny_fairy/view/settings/settings_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
      case RoutesName.loginOrSignup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginOrSignupView());
      case RoutesName.selectPassion:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SelectPassionView());
      case RoutesName.registerDetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterDetails());
      case RoutesName.uploadImg:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadImage());
      case RoutesName.selectPreference:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SelectPreference());

      case RoutesName.refrenceView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RefrenceView());

      case RoutesName.bookedView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BookedView());
      case RoutesName.communityView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CommunityView());
      case RoutesName.profileView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileView());
      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashBoardScreen());
      case RoutesName.uploadCommunityPost:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadComunityPost());
      case RoutesName.myProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MyProfile());
      // case RoutesName.editProfile:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const EditProfile());
      case RoutesName.notificationsView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NotificationsView());
      case RoutesName.settingsView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SettingsView());

      case RoutesName.totalRating:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TotalRatingScreen());
      // case RoutesName.addRating:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const Rating());

      case RoutesName.loginView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RoutesName.forgetPass:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPass());
      case RoutesName.uploadId:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadId());
      case RoutesName.selectPassionFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SelectPassionFamilyView());
      case RoutesName.registerFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterDetailsFamily());
      case RoutesName.uploadImgFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadImageFamily());
      case RoutesName.uploadIdFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadIdFamily());

      case RoutesName.dashboardFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashBoardFamilyScreen());
      // case RoutesName.communityDetailView:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const CommunityDetailView());

      case RoutesName.createAccount:
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateAccount());
      case RoutesName.availabilityView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AvailabilityView());
      case RoutesName.educationHorlyView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EducationHorlyView());
      case RoutesName.createAccountFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateAccountFamily());
      case RoutesName.homeViewFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeViewFamily());
      case RoutesName.uploadPostFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const UploadComunityPostFamily());
      // case RoutesName.communityDetailViewFamily:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           const CommunityDetailViewFamily());
      // case RoutesName.providerDetails:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const ProviderDetails());
      case RoutesName.filterPopUpFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FilterPopUpFamily());
      case RoutesName.settingsFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SettingsFamilyView());
      case RoutesName.myProfileFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MyProfileFamily());
      // case RoutesName.editProfileFamily:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const EditProfileFamily());
      case RoutesName.loginFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginViewFamily());
      case RoutesName.forgetPassFamily:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPassFamily());
      case RoutesName.familyNotifications:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FamilyNotificationsView());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No routes defined'),
            ),
          );
        });
    }
  }
}
