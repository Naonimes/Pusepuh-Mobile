// lib/views/post_card_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_profile_page.dart';
import 'thread_page.dart';

class PostCardWidget extends StatelessWidget {
  final Map threadItem;
  final Map post;
  final bool isDarkMode;
  final VoidCallback? onUpvotePressed;
  final VoidCallback? onRepostPressed;
  final VoidCallback? onReplyPressed;

  const PostCardWidget({
    super.key,
    required this.threadItem,
    required this.post,
    required this.isDarkMode,
    this.onUpvotePressed,
    this.onRepostPressed,
    this.onReplyPressed,
  });

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void bukaFullscreenGambar(String imageUrl) {
    Get.to(() => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true, boundaryMargin: const EdgeInsets.all(20), minScale: 0.5, maxScale: 4.0,
              child: Hero(tag: imageUrl, child: Image.network(imageUrl, fit: BoxFit.contain)),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    String bType = threadItem['boardType'] ?? 'Gallery';
    Color bColor = getBoardColor(bType);
    String creatorUser = post['userName'] ?? 'User';
    bool isUpvoted = post['isUpvoted'] ?? false;
    bool isReposted = post['isReposted'] ?? false;

    void arahkanKeProfil() {
      if (creatorUser == 'ujangasep') {
        Get.to(() => UserProfilePage(targetUser: 'ujangasep', isDarkMode: isDarkMode));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil @$creatorUser belum tersedia.'), duration: const Duration(seconds: 1)),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [if (!isDarkMode) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: arahkanKeProfil,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  child: Icon(Icons.person_outline_rounded, size: 22, color: subTextColor),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: arahkanKeProfil,
                      child: Text(creatorUser, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: bColor, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => Get.to(() => ThreadPage(
                                threadInfo: threadItem,
                                isDarkMode: isDarkMode,
                                onFollowChanged: (th, s) {},
                              )),
                          child: Text(threadItem['threadName'] ?? 'p/thread', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: bColor)),
                        ),
                        const SizedBox(width: 6),
                        Text('• ${post['time'] ?? 'Baru saja'}', style: TextStyle(fontSize: 10, color: subTextColor)),
                        if (post['isReposted'] == true && !(threadItem['isFromProfileTab'] ?? false)) ...[
                          const SizedBox(width: 6),
                          const Text('• (Direpost)', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          const SizedBox(height: 6),
          Text(post['caption'] ?? '', style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor)),
          if (post['hasImage'] == true) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => bukaFullscreenGambar(post['imageUrl'] ?? ''),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post['imageUrl'] ?? '',
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 190,
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(Icons.broken_image_outlined, color: subTextColor),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onUpvotePressed,
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 18, color: isUpvoted ? primaryBlue : subTextColor),
                    const SizedBox(width: 4),
                    Text('Up (${post['upvotes'] ?? 0})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isUpvoted ? primaryBlue : subTextColor)),
                  ],
                ),
              ),
              InkWell(
                onTap: onReplyPressed ?? () => Get.to(() => ThreadPage(threadInfo: threadItem, isDarkMode: isDarkMode, onFollowChanged: (th, s) {})),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 17, color: subTextColor),
                    const SizedBox(width: 4),
                    Text('${post['replies'] ?? 0} Reply', style: TextStyle(fontSize: 12, color: subTextColor)),
                  ],
                ),
              ),
              InkWell(
                onTap: onRepostPressed,
                child: Row(
                  children: [
                    Icon(Icons.repeat_rounded, size: 18, color: isReposted ? Colors.green : subTextColor),
                    const SizedBox(width: 4),
                    Text('Repost', style: TextStyle(fontSize: 12, color: isReposted ? Colors.green : subTextColor)),
                  ],
                ),
              ),
              Icon(Icons.share_outlined, size: 18, color: subTextColor),
            ],
          ),
        ],
      ),
    );
  }
}