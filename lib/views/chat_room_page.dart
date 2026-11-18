// lib/views/chat_room_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPage extends StatelessWidget {
  final String targetUser;
  final bool isDarkMode;
  final List existingMessages;

  ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.isDarkMode,
    required this.existingMessages,
  }) {
    messages.value = List.from(existingMessages);
  }

  final TextEditingController messageController = TextEditingController();
  final RxList messages = [].obs; // Reaktivitas lokal tanpa file controller terpisah

  void kirimPesan() {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    String jamSekarang = "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";

    messages.add({
      'sender': 'me',
      'text': text,
      'time': jamSekarang,
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: messages.toList()); // Kembalikan list pesan saat ditutup
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Get.back(result: messages.toList()),
          ),
          title: Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person, size: 18, color: primaryBlue)),
              const SizedBox(width: 10),
              Text(targetUser, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (messages.isEmpty) {
                    return Center(child: Text('Mulai obrolan dengan @$targetUser', style: TextStyle(color: subTextColor, fontSize: 13)));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var msg = messages[index];
                      bool isMe = msg['sender'] == 'me';

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: isMe ? primaryBlue : (isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100]), borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(msg['text'] ?? '', style: TextStyle(fontSize: 13, color: isMe ? Colors.white : textColor)),
                              const SizedBox(height: 2),
                              Text(msg['time'] ?? '', style: TextStyle(fontSize: 9, color: isMe ? Colors.white70 : subTextColor)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: cardColor, border: Border(top: BorderSide(color: borderColor))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: textColor, fontSize: 13),
                        decoration: InputDecoration(hintText: 'Tulis pesan...', hintStyle: TextStyle(color: subTextColor), border: InputBorder.none),
                      ),
                    ),
                    IconButton(onPressed: kirimPesan, icon: Icon(Icons.send_rounded, color: primaryBlue)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}