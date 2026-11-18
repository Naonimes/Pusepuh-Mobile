// lib/views/following_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/home_controller.dart';
import 'thread_page.dart';

class FollowingPage extends StatelessWidget {
  final bool isDarkMode;
  
  FollowingPage({super.key, required this.isDarkMode});

  final ProfileController profileC = Get.find<ProfileController>();
  final HomeController homeC = Get.find<HomeController>();

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Thread yang Diikuti', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
      ),
      // PERBAIKAN: Membungkus ListView dengan Obx yang aman menggunakan .obs getter controller
      body: Obx(() {
        List followedThreads = profileC.followedThreads;
        
        if (followedThreads.isEmpty) {
          return Center(child: Text('Kamu belum mengikuti thread apapun.', style: TextStyle(color: subTextColor, fontSize: 14)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: followedThreads.length,
          itemBuilder: (context, index) {
            var thread = followedThreads[index];
            String bType = thread['boardType'] ?? 'Gallery';
            Color bColor = getBoardColor(bType);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: bColor.withValues(alpha: 0.1), child: Icon(Icons.forum_rounded, color: bColor)),
                title: Text(thread['threadName'] ?? 'Thread', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: bColor)),
                subtitle: Text('Board: $bType', style: TextStyle(color: subTextColor, fontSize: 12)),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: subTextColor),
                onTap: () {
                  Get.to(() => ThreadPage(
                    threadInfo: thread,
                    isDarkMode: isDarkMode,
                    onFollowChanged: (updatedThread, status) {
                      homeC.toggleFollow(updatedThread);
                    },
                  ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}