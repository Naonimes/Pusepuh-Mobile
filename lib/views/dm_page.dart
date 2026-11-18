// lib/views/dm_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'chat_room_page.dart';

class DmPage extends StatelessWidget {
  final bool isDarkMode;

  DmPage({super.key, required this.isDarkMode});

  final HomeController homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text('History Message', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
      ),
      body: Obx(() {
        if (homeC.riwayatDm.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline_rounded, size: 54, color: subTextColor),
                const SizedBox(height: 12),
                Text('Kamu belum chat dengan siapapun', style: TextStyle(fontSize: 14, color: subTextColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Kunjungi profil seniman lain untuk mulai mengobrol!', style: TextStyle(fontSize: 12, color: subTextColor)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: homeC.riwayatDm.length,
          itemBuilder: (context, index) {
            var room = homeC.riwayatDm[index];
            String uname = (room['username'] ?? 'User').toString();
            String lastMsg = (room['lastMessage'] ?? '').toString();
            String waktunya = (room['time'] ?? '').toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person, color: primaryBlue)),
                title: Text(uname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: subTextColor)),
                trailing: Text(waktunya, style: TextStyle(fontSize: 10, color: subTextColor)),
                onTap: () async {
                  List existing = List.from(room['messages'] ?? []);

                  final hasilChat = await Get.to(() => ChatRoomPage(
                    targetUser: uname,
                    isDarkMode: isDarkMode,
                    existingMessages: existing,
                  ));

                  if (hasilChat != null && hasilChat is List) {
                    if (hasilChat.isNotEmpty) {
                      room['messages'] = hasilChat;
                      room['lastMessage'] = hasilChat.last['text'] ?? '';
                      room['time'] = hasilChat.last['time'] ?? '';
                      homeC.riwayatDm.refresh(); // Trigger update reaktif GetX
                    }
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}