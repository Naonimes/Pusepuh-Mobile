// lib/views/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final bool isDarkMode;
  
  EditProfilePage({super.key, required this.isDarkMode});

  final ProfileController profileC = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    // Ambil data terbaru dari controller
    final TextEditingController usernameController = TextEditingController(
      text: profileC.currentUserName.value == 'seniman_pusepuh' ? '' : profileC.currentUserName.value
    );
    final TextEditingController bioController = TextEditingController(text: profileC.userBio.value);
    final TextEditingController linkController = TextEditingController(text: profileC.userLink.value);

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
        title: Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
        actions: [
          TextButton(
            onPressed: () {
              profileC.saveProfile(usernameController.text.trim(), bioController.text.trim(), linkController.text.trim());
              Get.back();
            },
            child: Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 15)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(radius: 46, backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person_outline_rounded, size: 50, color: primaryBlue)),
                Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle, border: Border.all(color: bgColor, width: 2)), child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
          const SizedBox(height: 6),
          TextField(controller: usernameController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(filled: true, fillColor: cardColor, hintText: 'Masukkan username...', hintStyle: TextStyle(color: subTextColor), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryBlue)))),
          const SizedBox(height: 16),
          Text('Bio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
          const SizedBox(height: 6),
          TextField(controller: bioController, maxLines: 3, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(filled: true, fillColor: cardColor, hintText: 'Tuliskan bio singkat tentang dirimu...', hintStyle: TextStyle(color: subTextColor), contentPadding: const EdgeInsets.all(14), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryBlue)))),
          const SizedBox(height: 16),
          Text('Tautan / Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
          const SizedBox(height: 6),
          TextField(controller: linkController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(filled: true, fillColor: cardColor, hintText: 'https://...', hintStyle: TextStyle(color: subTextColor), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryBlue)))),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => profileC.logout(),
              icon: const Icon(Icons.logout_rounded, size: 18), label: const Text('Keluar Akun (Log Out)'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}