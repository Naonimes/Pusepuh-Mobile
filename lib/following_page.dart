import 'package:flutter/material.dart';
import 'data_dummy.dart';

class FollowingPage extends StatelessWidget {
  final bool isDarkMode;

  const FollowingPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    // Ambil semua thread yang isFollowed == true
    List followedThreads = masterThreads.where((t) => t['isFollowed'] == true).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Thread yang Diikuti',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
        ),
      ),
      body: followedThreads.isEmpty
          ? Center(
              child: Text(
                'Kamu belum mengikuti thread apapun.',
                style: TextStyle(color: subTextColor, fontSize: 14),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: followedThreads.length,
              itemBuilder: (context, index) {
                var thread = followedThreads[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      child: const Icon(Icons.forum_rounded, color: Colors.blue),
                    ),
                    title: Text(
                      thread['threadName'] ?? 'Thread',
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
                    ),
                    subtitle: Text(
                      'Diikuti',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}