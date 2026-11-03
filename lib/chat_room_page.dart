import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final String targetUser;
  final bool isDarkMode;

  // Constructor yang bersih, sudah tidak butuh initialMessages!
  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.isDarkMode,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController messageController = TextEditingController();
  
  final List messages = [
    {
      'sender': 'ujangasep',
      'text': 'Bang, tutor shading rambut anime dong, aku nyerah nih',
      'time': '10:00',
    },
  ];

  void kirimPesan() {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    String jamSekarang = "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";

    setState(() {
      messages.add({
        'sender': 'me',
        'text': text,
        'time': jamSekarang,
      });
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              child: Icon(Icons.person, size: 18, color: primaryBlue),
            ),
            const SizedBox(width: 10),
            Text(
              widget.targetUser,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                    decoration: BoxDecoration(
                      color: isMe ? primaryBlue : (widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'] ?? '',
                          style: TextStyle(fontSize: 13, color: isMe ? Colors.white : textColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          msg['time'] ?? '',
                          style: TextStyle(fontSize: 9, color: isMe ? Colors.white70 : subTextColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: textColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      hintStyle: TextStyle(color: subTextColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: kirimPesan,
                  icon: Icon(Icons.send_rounded, color: primaryBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}