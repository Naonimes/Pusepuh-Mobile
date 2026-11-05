import 'package:flutter/material.dart';
import 'data_dummy.dart';
import 'thread_page.dart';

class NotificationPage extends StatelessWidget {
  final bool isDarkMode;
  final bool isLoggedIn;
  final String loggedInUser;
  final VoidCallback onLoginRequired;
  final Function(Map, bool) onFollowChanged;

  const NotificationPage({
    super.key,
    required this.isDarkMode,
    required this.isLoggedIn,
    required this.loggedInUser,
    required this.onLoginRequired,
    required this.onFollowChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color primaryBlue = const Color(0xFF2563EB);
    Color unreadBgColor = isDarkMode ? primaryBlue.withValues(alpha: 0.15) : primaryBlue.withValues(alpha: 0.08);
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    // Mengambil postingan ujangasep dari data_dummy secara otomatis
    Map targetThread = masterThreads.firstWhere(
      (t) => t['post']['userName'] == 'ujangasep',
      orElse: () => masterThreads[0],
    );
    String threadName = targetThread['threadName'] ?? 'p/kritik_saran';
    String postTitle = targetThread['post']['title'] ?? 'Postingan Baru';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              // Langsung loncat ke halaman Thread ujangasep saat notif ditekan!
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThreadPage(
                    threadInfo: targetThread,
                    isDarkMode: isDarkMode,
                    isLoggedIn: isLoggedIn,
                    loggedInUser: loggedInUser,
                    onLoginRequired: onLoginRequired,
                    onFollowChanged: onFollowChanged,
                  ),
                ),
              );
            },
            child: Container(
              color: unreadBgColor, // Background khusus untuk notif yang belum dibaca
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    child: Icon(Icons.person, size: 24, color: primaryBlue),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13.5, color: textColor, height: 1.4),
                            children: [
                              const TextSpan(
                                text: 'ujangasep ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: 'membuat postingan baru untuk meminta saran di board '),
                              TextSpan(
                                text: threadName,
                                style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
                              ),
                              const TextSpan(text: ':\n'),
                              TextSpan(
                                text: '"$postTitle"',
                                style: TextStyle(color: subTextColor, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Baru saja',
                          style: TextStyle(fontSize: 11, color: primaryBlue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Indikator titik biru (belum dibaca)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: borderColor, height: 1, thickness: 1),
        ],
      ),
    );
  }
}