import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../res/components/colors.dart';
import 'package:intl/intl.dart';
import '../../../res/components/widgets/vertical_spacing.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    required this.profilePic,
    required this.name,
    required this.rating,
    required this.time,
    required this.comment,
    required this.imgUrl,
  });
  final String profilePic;
  final String name;
  final String rating;
  final String time;
  final String comment;
  final String imgUrl;
  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String formatDateAndTime(String time) {
    DateTime dateTime = DateTime.now();
    String formattedDateTime =
        "${DateFormat.MMMd().format(dateTime)},${DateFormat.y().format(dateTime)},${DateFormat.jm().format(dateTime)}";
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.creamyColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=1587&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      foregroundImage: NetworkImage(widget.profilePic),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontFamily: 'CenturyGothic',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor,
                          ),
                        ),
                        RatingBar.builder(
                            initialRating: double.parse(widget.rating),
                            minRating: 1,
                            allowHalfRating: true,
                            glowColor: AppColor.peachColor,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star_rate_rounded,
                                  color: AppColor.peachColor,
                                ),
                            onRatingUpdate: (rating) {}),
                      ],
                    ),
                  ],
                ),
                Text(
                  formatDateAndTime(
                    widget.time,
                  ),
                  style: const TextStyle(
                    fontFamily: 'CenturyGothic',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.grayColor,
                  ),
                ),
              ],
            ),
            const VerticalSpeacing(8),
            Text(
              widget.comment,
              style: const TextStyle(
                fontFamily: 'CenturyGothic',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.grayColor,
              ),
            ),
            const VerticalSpeacing(14),
          ],
        ),
      ),
    );
  }
}
