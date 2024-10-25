import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nanny_fairy/FamilyController/family_auth_controller.dart';
import 'package:nanny_fairy/FamilyController/family_community_controller.dart';
import 'package:nanny_fairy/FamilyController/family_home_controller.dart';
import 'package:nanny_fairy/FamilyController/get_family_info_controller.dart';
import 'package:nanny_fairy/Repository/auth_repository.dart';
import 'package:nanny_fairy/Repository/community_repo_family.dart';
import 'package:nanny_fairy/Repository/community_repo_provider.dart';
import 'package:nanny_fairy/Repository/family_auth_repository.dart';
import 'package:nanny_fairy/Repository/family_chat_repository.dart';
import 'package:nanny_fairy/Repository/family_distance_repository.dart';
import 'package:nanny_fairy/Repository/family_home_repo.dart';
import 'package:nanny_fairy/Repository/family_home_ui_repository.dart';
import 'package:nanny_fairy/Repository/family_search_repository.dart';
import 'package:nanny_fairy/Repository/family_filter_repository.dart';
import 'package:nanny_fairy/Repository/filter_repository.dart';
import 'package:nanny_fairy/Repository/get_family_info_repo.dart';
import 'package:nanny_fairy/Repository/get_provider_info.dart';
import 'package:nanny_fairy/Repository/home_ui_repostory.dart';
import 'package:nanny_fairy/Repository/place_repository.dart';
import 'package:nanny_fairy/Repository/provider_chat_repository.dart';
import 'package:nanny_fairy/Repository/provider_home_repository.dart';
import 'package:nanny_fairy/Repository/search_repository.dart';
import 'package:nanny_fairy/Repository/provider_distance_repository.dart';
import 'package:nanny_fairy/ViewModel/auth_view_model.dart';
import 'package:nanny_fairy/ViewModel/family_chat_view_model.dart';
import 'package:nanny_fairy/ViewModel/family_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/family_filter_view_model.dart';
import 'package:nanny_fairy/ViewModel/family_search_view_model.dart';
import 'package:nanny_fairy/ViewModel/community_view_view_model.dart';
import 'package:nanny_fairy/ViewModel/filter_view_model.dart';
import 'package:nanny_fairy/ViewModel/get_provider_info_view_model.dart';
import 'package:nanny_fairy/ViewModel/place_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_chat_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_distance_view_model.dart';
import 'package:nanny_fairy/ViewModel/provider_home_view_model.dart';
import 'package:nanny_fairy/ViewModel/search_view_model.dart';
import 'package:nanny_fairy/res/components/colors.dart';
import 'package:nanny_fairy/utils/routes/routes.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/view/onboarding/splash_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51PlW60P8NBIKG6QO0dHfDou7Jlnpx3KPGruG9S4JTX4PQfgFyjIIlKXmEuoSO1e5ksahBTuSM0Hdk4cKbgYR7YvM00awJvQ8KQ";
  Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) =>
                  FamilyDistanceViewModel(FamilyDistanceRepository())),
          ChangeNotifierProvider(
              create: (_) => PlaceViewModel(SearchPlaceRepository())),
          ChangeNotifierProvider(
              create: (_) =>
                  ProviderDistanceViewModel(ProviderDistanceRepository())),
          Provider<AuthRepository>(create: (_) => AuthRepository()),
          Provider<AuthRepositoryFamily>(create: (_) => AuthRepositoryFamily()),
          Provider<ProviderHomeRepository>(
            create: (_) => ProviderHomeRepository(),
          ),
          Provider<FamilyHomeRepository>(create: (_) => FamilyHomeRepository()),
          ChangeNotifierProvider<SearchRepository>(
              create: (_) => SearchRepository()),
          ChangeNotifierProvider<FamilyFilterRepository>(
              create: (context) => FamilyFilterRepository()),
          ChangeNotifierProvider<FilteredRepository>(
              create: (context) =>
                  FilteredRepository(context.read<SearchRepository>())),
          ChangeNotifierProvider<AuthViewModel>(
              create: (context) =>
                  AuthViewModel(context.read<AuthRepository>())),
          ChangeNotifierProvider<FamilyAuthController>(
              create: (context) =>
                  FamilyAuthController(context.read<AuthRepositoryFamily>())),
          ChangeNotifierProvider<ProviderHomeViewModel>(
              create: (context) => ProviderHomeViewModel(
                  context.read<ProviderHomeRepository>())),
          ChangeNotifierProvider<FamilyHomeController>(
              create: (context) =>
                  FamilyHomeController(context.read<FamilyHomeRepository>())),
          ChangeNotifierProvider<HomeUiSwithchRepository>(
              create: (_) => HomeUiSwithchRepository()),
          ChangeNotifierProvider(create: (_) => FamilyHomeUiRepository()),
          ChangeNotifierProvider<FilteredViewModel>(
              create: (context) =>
                  FilteredViewModel(context.read<FilteredRepository>())),
          ChangeNotifierProvider<SearchViewModel>(
            create: (context) =>
                SearchViewModel(context.read<SearchRepository>()),
          ),
          ChangeNotifierProvider(
              create: (_) => FamilySearchViewModel(FamilySearchRepository())),
          Provider<CommunityRepoFamily>(
            create: (_) => CommunityRepoFamily(),
          ),
          ChangeNotifierProvider<FamilyCommunityController>(
              create: (context) => FamilyCommunityController(
                  context.read<CommunityRepoFamily>())),
          Provider<CommunityRepoProvider>(
            create: (_) => CommunityRepoProvider(),
          ),
          ChangeNotifierProvider<CommunityViewViewModel>(
              create: (context) => CommunityViewViewModel(
                  context.read<CommunityRepoProvider>())),
          ChangeNotifierProvider<FamilyFilterController>(
              create: (context) => FamilyFilterController(
                  context.read<FamilyFilterRepository>())),
          Provider<GetProviderInfoRepo>(
            create: (_) => GetProviderInfoRepo(),
          ),
          ChangeNotifierProvider<GetProviderInfoViewModel>(
              create: (context) => GetProviderInfoViewModel(
                  context.read<GetProviderInfoRepo>())),
          Provider<GetFamilyInfoRepo>(
            create: (_) => GetFamilyInfoRepo(),
          ),
          ChangeNotifierProvider<GetFamilyInfoController>(
              create: (context) =>
                  GetFamilyInfoController(context.read<GetFamilyInfoRepo>())),
          ChangeNotifierProvider(
            create: (_) => FamilyChatController(
              familyChatRepository: FamilyChatRepository(),
            )..loadChats(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProvidersChatController(
              providerChatRepository: ProviderChatRepository(),
            )..loadChats(),
          ),
        ],
        child: MaterialApp(
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.whiteColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.primaryColor,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
