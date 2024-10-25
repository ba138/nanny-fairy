import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/ViewModel/community_view_view_model.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/view/community/widgets/community_detail_view.dart';
import 'package:nanny_fairy/view/community/widgets/community_widget.dart';
import 'package:provider/provider.dart';
import '../../res/components/colors.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  void initState() {
    super.initState();
    final communityController =
        Provider.of<CommunityViewViewModel>(context, listen: false);
    communityController.fetchProviderPosts();
  }

  @override
  Widget build(BuildContext context) {
    final communityController = Provider.of<CommunityViewViewModel>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.secondaryBgColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Community',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.uploadCommunityPost);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  height: 31,
                  width: 97,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
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
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColor.avatarColor,
            labelColor: AppColor.avatarColor,
            unselectedLabelColor: AppColor.whiteColor,
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
                    if (communityController.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (communityController.posts.isEmpty)
                      const Center(child: Text('No posts found'))
                    else
                      Column(
                        children: communityController.posts
                            .where((post) =>
                                post['status'] ==
                                true) // Filter posts with status true
                            .map((post) {
                          return FutureBuilder<int>(
                            future: communityController
                                .fetchTotalComments(post['postId']),
                            builder: (context, snapshot) {
                              final totalComments = snapshot.data ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommunityDetailView(
                                        img: post['post'],
                                        title: post['title'],
                                        subtitle: post['content'],
                                        postId: post['postId'],
                                        userId: currentUserId,
                                      );
                                    }));
                                  },
                                  child: CommunituCartWidget(
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
                    if (communityController.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (communityController.posts.isEmpty)
                      const Center(child: Text('No posts found'))
                    else
                      Column(
                        children: communityController.posts
                            .where((post) => post['userId'] == currentUserId)
                            .map((post) {
                          return FutureBuilder<int>(
                            future: communityController
                                .fetchTotalComments(post['postId']),
                            builder: (context, snapshot) {
                              final totalComments = snapshot.data ?? 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommunityDetailView(
                                        img: post['post'],
                                        title: post['title'],
                                        subtitle: post['content'],
                                        postId: post['postId'],
                                        userId: currentUserId,
                                      );
                                    }));
                                  },
                                  child: CommunituCartWidget(
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
