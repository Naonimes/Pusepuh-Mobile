import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserName;
  final bool isDarkMode;
  final Function(String, String, String) onProfileSaved;
  final VoidCallback onLogout;

  const EditProfilePage({
    super.key,
    required this.currentUserName,
    required this.isDarkMode,
    required this.onProfileSaved,
    required this.onLogout,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController bioController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();
    // Dibuat kosong sesuai permintaanmu
    usernameController = TextEditingController(text: widget.currentUserName == 'seniman_pusepuh' ? '' : widget.currentUserName);
    bioController = TextEditingController();
    linkController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newName = usernameController.text.trim();
              String newBio = bioController.text.trim();
              String newLink = linkController.text.trim();

              widget.onProfileSaved(
                newName.isEmpty ? 'Seniman Tanpa Nama' : newName,
                newBio,
                newLink,
              );
              Navigator.pop(context);
            },
            child: Text(
              'Simpan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryBlue,
                fontSize: 15,
              ),
            ),
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
                CircleAvatar(
                  radius: 46,
                  backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  child: Icon(Icons.person_outline_rounded, size: 50, color: primaryBlue),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: bgColor, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Username',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: usernameController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardColor,
              hintText: 'Masukkan username...',
              hintStyle: TextStyle(color: subTextColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Bio',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: bioController,
            maxLines: 3,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardColor,
              hintText: 'Tuliskan bio singkat tentang dirimu...',
              hintStyle: TextStyle(color: subTextColor),
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Tautan / Link',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: linkController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardColor,
              hintText: 'https://...',
              hintStyle: TextStyle(color: subTextColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onLogout();
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Keluar Akun (Log Out)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}