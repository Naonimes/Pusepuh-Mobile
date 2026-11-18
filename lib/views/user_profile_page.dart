// lib/views/user_profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/data_dummy.dart';
import '../controllers/home_controller.dart';
import 'chat_room_page.dart';

class UserProfilePage extends StatelessWidget {
  final String targetUser;
  final bool isDarkMode;

  UserProfilePage({super.key, required this.targetUser, required this.isDarkMode});

  final HomeController homeC = Get.find<HomeController>();

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void bukaChat() async {
    Map? existingRoom;
    for (var room in homeC.riwayatDm) {
      if (room['username'] == targetUser) {
        existingRoom = room;
        break;
      }
    }

    List currentMessages = [];
    if (existingRoom != null) {
      currentMessages = List.from(existingRoom['messages'] ?? []);
    }

    final hasilChat = await Get.to(() => ChatRoomPage(
          targetUser: targetUser,
          isDarkMode: isDarkMode,
          existingMessages: currentMessages,
        ));

    if (hasilChat != null && hasilChat is List) {
      if (hasilChat.isNotEmpty) {
        if (existingRoom != null) {
          existingRoom['messages'] = hasilChat;
          existingRoom['lastMessage'] = hasilChat.last['text'] ?? '';
          existingRoom['time'] = hasilChat.last['time'] ?? '';
        } else {
          homeC.riwayatDm.add({
            'username': targetUser,
            'lastMessage': hasilChat.last['text'] ?? '',
            'time': hasilChat.last['time'] ?? '',
            'messages': hasilChat,
          });
        }
        homeC.riwayatDm.refresh(); // Trigger update UI riwayat DM
      }
    }
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
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List userPosts = [];
    for (var t in masterThreads) {
      if (t['post']['userName'] == targetUser) {
        userPosts.add(t);
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text('@$targetUser', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
            child: Column(
              children: [
                CircleAvatar(radius: 40, backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person, size: 45, color: primaryBlue)),
                const SizedBox(height: 12),
                Text(targetUser, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                const SizedBox(height: 6),
                Text('Pemula digital art yang lagi berjuang belajar shading rambut anime! 🎨✨', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: subTextColor)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: bukaChat,
                  icon: const Icon(Icons.mail_outline_rounded, size: 18), label: const Text('Kirim Pesan'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Postingan $targetUser', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          const SizedBox(height: 12),
          if (userPosts.isEmpty)
            Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text('Belum ada postingan.', style: TextStyle(color: subTextColor, fontSize: 13))))
          else
            ...userPosts.map((threadItem) {
              var post = threadItem['post'];
              String bType = threadItem['boardType'] ?? 'Gallery';
              Color bColor = getBoardColor(bType);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 16, backgroundColor: Colors.grey[200], child: Icon(Icons.person, size: 18, color: subTextColor)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(targetUser, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: BoxDecoration(color: bColor, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text(threadItem['threadName'] ?? 'p/thread', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: bColor)),
                                  const SizedBox(width: 6),
                                  Text('• ${post['time'] ?? ''}', style: TextStyle(fontSize: 10, color: subTextColor)),
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
                        child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Hero(tag: 'user_${post['imageUrl']}', child: Image.network(post['imageUrl'] ?? '', width: double.infinity, height: 190, fit: BoxFit.cover))),
                      ),
                    ],
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}