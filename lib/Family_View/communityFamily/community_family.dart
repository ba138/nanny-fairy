import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/FamilyController/family_community_controller.dart';
import 'package:nanny_fairy/Family_View/communityFamily/community_detail_family.dart';
import 'package:nanny_fairy/Family_View/communityFamily/widgets/community_card_family.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class CommunityViewFamily extends StatefulWidget {
  const CommunityViewFamily({super.key});

  @override
  State<CommunityViewFamily> createState() => _CommunityViewFamilyState();
}

class _CommunityViewFamilyState extends State<CommunityViewFamily> {
  @override
  void initState() {
    super.initState();
    final familyCommunityController =
        Provider.of<FamilyCommunityController>(context, listen: false);
    familyCommunityController.fetchFamilyPosts();
  }

  @override
  Widget build(BuildContext context) {
    final familyCommunityController =
        Provider.of<FamilyCommunityController>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.creamyColor,
        appBar: AppBar(
          backgroundColor: AppColor.lavenderColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Community',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColor.creamyColor,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.uploadPostFamily);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  height: 31,
                  width: 97,
                  decoration: BoxDecoration(
                    color: AppColor.creamyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Post',
                      style: GoogleFonts.getFont(
                        "Poppins",
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lavenderColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColor.peachColor,
            labelColor: AppColor.peachColor,
            unselectedLabelColor: AppColor.creamyColor,
            tabs: [
              Tab(text: 'Topics'),
              Tab(text: 'My Posts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Topics View
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpeacing(16.0),
                    if (familyCommunityController.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (familyCommunityController.posts.isEmpty)
                      const Center(child: Text('No posts found'))
                    else
                      Column(
                        children: familyCommunityController.posts
                            .where((post) => post['status'] == true)
                            .map((post) {
                          return FutureBuilder<int>(
                            future: familyCommunityController
                                .fetchTotalComments(post['postId']),
                            builder: (context, snapshot) {
                              final totalComments = snapshot.data ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommunityDetailViewFamily(
                                        img: post['post'],
                                        title: post['title'],
                                        subtitle: post['content'],
                                        postId: post['postId'],
                                        userId: currentUserId,
                                      );
                                    }));
                                  },
                                  child: CommunituCartWidgetFamily(
                                    post: post['post'],
                                    title: post['title'],
                                    content: post['content'],
                                    totalComments: totalComments,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            // My Posts View
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpeacing(16.0),
                    if (familyCommunityController.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (familyCommunityController.posts.isEmpty)
                      const Center(child: Text('No posts found'))
                    else
                      Column(
                        children: familyCommunityController.posts
                            .where((post) => post['userId'] == currentUserId)
                            .map((post) {
                          return FutureBuilder<int>(
                            future: familyCommunityController
                                .fetchTotalComments(post['postId']),
                            builder: (context, snapshot) {
                              final totalComments = snapshot.data ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommunityDetailViewFamily(
                                        img: post['post'],
                                        title: post['title'],
                                        subtitle: post['content'],
                                        postId: post['postId'],
                                        userId: currentUserId,
                                      );
                                    }));
                                  },
                                  child: CommunituCartWidgetFamily(
                                    post: post['post'],
                                    title: post['title'],
                                    content: post['content'],
                                    totalComments: totalComments,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
