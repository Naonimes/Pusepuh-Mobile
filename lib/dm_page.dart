import 'package:flutter/material.dart';

class DmPage extends StatelessWidget {
  final bool isDarkMode;

  const DmPage({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline_rounded, size: 54, color: subTextColor),
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
              'Mulai obrolan dengan mengunjungi profil seniman lain!',
              style: TextStyle(fontSize: 12, color: subTextColor),
            ),
          ],
        ),
      ),
    );
  }
}