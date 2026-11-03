import 'package:flutter/material.dart';
import 'chat_room_page.dart';

class DmPage extends StatefulWidget {
  final bool isDarkMode;
  final List riwayatDm;

  const DmPage({
    super.key,
    required this.isDarkMode,
    required this.riwayatDm,
  });

  @override
  State<DmPage> createState() => _DmPageState();
}

class _DmPageState extends State<DmPage> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor =
        widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor =
        widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'History Message',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      body: widget.riwayatDm.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline_rounded,
                      size: 54, color: subTextColor),
                  const SizedBox(height: 12),
                  Text(
                    'Kamu belum chat dengan siapapun',
                    style: TextStyle(
                      fontSize: 14,
                      color: subTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kunjungi profil seniman lain untuk mulai mengobrol!',
                    style: TextStyle(fontSize: 12, color: subTextColor),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.riwayatDm.length,
              itemBuilder: (context, index) {
                var room = widget.riwayatDm[index];
                String uname = (room['username'] ?? 'User').toString();
                String lastMsg = (room['lastMessage'] ?? '').toString();
                String waktunya = (room['time'] ?? '').toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: widget.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      child: Icon(Icons.person, color: primaryBlue),
                    ),
                    title: Text(
                      uname,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor),
                    ),
                    subtitle: Text(
                      lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                    trailing: Text(
                      waktunya,
                      style: TextStyle(fontSize: 10, color: subTextColor),
                    ),
                    onTap: () async {
                      List existing = List.from(room['messages'] ?? []);

                      final hasilChat = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomPage(
                            targetUser: uname,
                            isDarkMode: widget.isDarkMode,
                            existingMessages: existing,
                          ),
                        ),
                      );

                      if (hasilChat != null && hasilChat is List) {
                        if (hasilChat.isNotEmpty) {
                          setState(() {
                            room['messages'] = hasilChat;
                            room['lastMessage'] =
                                hasilChat.last['text'] ?? '';
                            room['time'] = hasilChat.last['time'] ?? '';
                          });
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}