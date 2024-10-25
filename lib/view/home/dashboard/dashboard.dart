// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:nanny_fairy/ViewModel/provider_home_view_model.dart';
import 'package:nanny_fairy/view/booked/booked_view.dart';
import 'package:nanny_fairy/view/community/community_view.dart';
import 'package:nanny_fairy/view/home/home_view.dart';
import 'package:nanny_fairy/view/profile/profile_view.dart';
import 'package:provider/provider.dart';
import '../../../res/components/colors.dart';
import '../../chat/chat_list.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectIndex = 0;
  onItemClick(int index) {
    setState(() {
      selectIndex = index;
      tabController!.index = selectIndex;
    });
  }
  // for profile

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 5, vsync: this);
    Provider.of<ProviderHomeViewModel>(context, listen: false).getCurrentUser();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  // popUp
  void showSignupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.creamyColor,
          shape: const RoundedRectangleBorder(),
          icon: const Icon(
            Icons.no_accounts_outlined,
            size: 80,
            color: AppColor.lavenderColor,
          ),
          title: const Text('You don\'t have any account, please'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lavenderColor,
                  shape: const RoundedRectangleBorder(),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, RoutesName.loginscreen);
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: AppColor.creamyColor),
                ),
              ),
              const SizedBox(height: 12.0), // Vertical spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  shape: const RoundedRectangleBorder(),
                  side: const BorderSide(
                    color: AppColor.lavenderColor, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, RoutesName.registerScreen);
                },
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: AppColor.lavenderColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamyColor,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeView(),
          ChatList(),
          BookedView(),
          CommunityView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            backgroundColor: AppColor.creamyColor,
            icon: ImageIcon(
              AssetImage('images/home.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/chatting.png'),
            ),
            label: ('chat'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/booked.png'),
            ),
            label: ('Booked'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            label: ('community'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: ('profile'),
          ),
        ],
        unselectedItemColor: AppColor.grayColor,
        selectedItemColor: AppColor.lavenderColor,
        backgroundColor: AppColor.creamyColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: onItemClick,
      ),
    );
  }
}
