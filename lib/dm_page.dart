import 'package:flutter/material.dart';
import 'chat_room_page.dart';

class DmPage extends StatelessWidget {
  final bool isDarkMode;

  const DmPage({
    super.key,
    required this.isDarkMode,
  });

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Icon(Icons.person, color: primaryBlue),
              ),
              title: Text(
                'ujangasep',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
              ),
              subtitle: Text(
                'Bang, tutor shading rambut anime dong, aku nyerah nih',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
              trailing: Text(
                'Kemarin',
                style: TextStyle(fontSize: 10, color: subTextColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(targetUser: 'ujangasep', isDarkMode: isDarkMode),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}