// lib/views/profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/home_controller.dart';
import 'following_page.dart';
import 'edit_profile_page.dart';
import 'thread_page.dart';
import 'post_card_widget.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final bool isDarkMode;
  final List<String> selectedTopics;
  final VoidCallback onLogout;

  ProfilePage({
    super.key,
    required this.userName,
    required this.isDarkMode,
    required this.selectedTopics,
    required this.onLogout,
  });

  final ProfileController profileC = Get.put(ProfileController());
  final HomeController homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color cardColor = homeC.isDarkMode.value ? const Color(0xFF1E1E1E) : Colors.white;
      Color textColor = homeC.isDarkMode.value ? Colors.white : Colors.black87;
      Color subTextColor = homeC.isDarkMode.value ? Colors.grey[400]! : Colors.grey[600]!;
      Color borderColor = homeC.isDarkMode.value ? Colors.grey[800]! : Colors.grey[200]!;
      Color primaryBlue = const Color(0xFF2563EB);

      List followedThreads = profileC.followedThreads;
      int followingCount = followedThreads.length;
      List repostedItems = profileC.repostedItems;
      List myCreatedItems = profileC.myCreatedItems;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: homeC.isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
                  child: Icon(Icons.person_outline_rounded, size: 42, color: primaryBlue),
                ),
                const SizedBox(height: 12),
                Text(
                  profileC.currentUserName.value.isEmpty ? 'User Pusepuh' : profileC.currentUserName.value,
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
                ),
                if (profileC.userBio.value.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(profileC.userBio.value, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: subTextColor)),
                ],
                if (profileC.userLink.value.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(profileC.userLink.value, style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.w500)),
                ],
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Get.to(() => FollowingPage(isDarkMode: homeC.isDarkMode.value));
                  },
                  child: Column(
                    children: [
                      Text(followingCount.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                      Text('Following Thread', style: TextStyle(fontSize: 12, color: subTextColor)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () {
                    Get.to(() => EditProfilePage(isDarkMode: homeC.isDarkMode.value));
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderColor, width: 1.5))),
            child: Row(
              children: List.generate(profileC.profileTabs.length, (index) {
                bool isSelected = profileC.selectedProfileTab.value == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => profileC.ubahProfileTab(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? primaryBlue : Colors.transparent, width: 3))),
                      child: Text(profileC.profileTabs[index], textAlign: TextAlign.center, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13, color: isSelected ? primaryBlue : subTextColor)),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          if (profileC.selectedProfileTab.value == 0) ...[
            if (repostedItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Text('Belum ada postingan yang kamu repost.', style: TextStyle(color: subTextColor, fontSize: 13))),
              )
            else
              ...repostedItems.map((item) {
                var threadItem = Map.from(item['thread']);
                threadItem['isFromProfileTab'] = true;
                var post = item['post'] ?? {};

                return PostCardWidget(
                  threadItem: threadItem,
                  post: post,
                  isDarkMode: homeC.isDarkMode.value,
                  onUpvotePressed: () {
                    bool isUp = post['isUpvoted'] ?? false;
                    int upvotes = post['upvotes'] ?? 0;
                    post['isUpvoted'] = !isUp;
                    post['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
                    profileC.refresh();
                  },
                  onRepostPressed: () {
                    post['isReposted'] = !(post['isReposted'] ?? false);
                    profileC.refresh();
                  },
                );
              })
          ] else ...[
            if (myCreatedItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Text('Belum ada postingan atau thread yang kamu buat.', style: TextStyle(color: subTextColor, fontSize: 13))),
              )
            else
              ...myCreatedItems.map((item) {
                var threadItem = item['thread'];
                var post = item['post'] ?? {};

                return PostCardWidget(
                  threadItem: threadItem,
                  post: post,
                  isDarkMode: homeC.isDarkMode.value,
                  onUpvotePressed: () {
                    bool isUp = post['isUpvoted'] ?? false;
                    int upvotes = post['upvotes'] ?? 0;
                    post['isUpvoted'] = !isUp;
                    post['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
                    profileC.refresh();
                  },
                  onRepostPressed: () {
                    post['isReposted'] = !(post['isReposted'] ?? false);
                    profileC.refresh();
                  },
                );
              })
          ],
        ],
      );
    });
  }
}