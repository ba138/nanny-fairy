// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:nanny_fairy/FamilyController/get_family_info_controller.dart';
import 'package:nanny_fairy/Family_View/bookFamily/book_view_family.dart';
import 'package:nanny_fairy/Family_View/familyChat/family_chat_list.dart';
import 'package:nanny_fairy/Family_View/homeFamily/home_view_family.dart';
import 'package:provider/provider.dart';

import '../../../res/components/colors.dart';
import '../../communityFamily/community_family.dart';
import '../../profileFamily/profile_family.dart';

class DashBoardFamilyScreen extends StatefulWidget {
  const DashBoardFamilyScreen({super.key});

  @override
  State<DashBoardFamilyScreen> createState() => _DashBoardFamilyScreenState();
}

class _DashBoardFamilyScreenState extends State<DashBoardFamilyScreen>
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
    Provider.of<GetFamilyInfoController>(context, listen: false)
        .getFamilyInfo();
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeViewFamily(),
          FamilyChatList(),
          BookedViewFamily(),
          CommunityViewFamily(),
          ProfileViewFamily(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
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
            label: ('Opdrachten'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            label: ('community'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: ('Profiel'),
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
