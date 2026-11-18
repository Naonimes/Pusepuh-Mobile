// lib/views/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final bool isDarkMode;
  RegisterPage({super.key, required this.isDarkMode});

  final AuthController authC = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final List<String> availableTopics = [
    'Melihat tutorial art',
    'Meminta kritik saran',
    'Mengajar artist newbie',
    'Melihat gambar dan media hiburan',
    'Mengetahui info update seputar dunia artist',
  ];

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
        centerTitle: true,
        title: Text('pusepuh', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22, color: primaryBlue)),
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (authC.registerStep.value == 0) ...[
              Text('Buat Akun Baru', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22, color: textColor)),
              const SizedBox(height: 6),
              Text('Bergabunglah bersama komunitas seniman visual Indonesia.', style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 20),
              
              if (authC.registerError.value.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.redAccent)),
                  child: Text(authC.registerError.value, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                ),

              Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: emailController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'contoh: seniman@email.com', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
              const SizedBox(height: 14),

              Text('Username', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: usernameController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Huruf kecil, angka, titik, atau underscore', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
              const SizedBox(height: 14),

              Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: passwordController, obscureText: authC.obscurePassword.value, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Min. 8 digit (Huruf besar, kecil & angka)', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none, suffixIcon: IconButton(icon: Icon(authC.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: subTextColor, size: 20), onPressed: () => authC.togglePasswordVisibility())))),
              const SizedBox(height: 14),

              Text('Konfirmasi Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: confirmPasswordController, obscureText: authC.obscureConfirm.value, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Masukkan ulang password kamu', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none, suffixIcon: IconButton(icon: Icon(authC.obscureConfirm.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: subTextColor, size: 20), onPressed: () => authC.toggleConfirmVisibility())))),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () => authC.lanjutKeTopik(emailController.text, usernameController.text, passwordController.text, confirmPasswordController.text),
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Lanjut', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ] 
            else if (authC.registerStep.value == 1) ...[
              Text('Apa Alasanmu Mengunduh Pusepuh?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20, color: textColor)),
              const SizedBox(height: 6),
              Text('Pilih topik yang kamu inginkan agar konten thread di beranda sesuai dengan minatmu.', style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 16),
              
              if (authC.registerError.value.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.redAccent)),
                  child: Text(authC.registerError.value, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                ),

              ...availableTopics.map((topic) {
                bool isPicked = authC.chosenTopics.contains(topic);
                return GestureDetector(
                  onTap: () => authC.toggleTopicSelection(topic),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(color: isPicked ? primaryBlue.withValues(alpha: 0.12) : cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: isPicked ? primaryBlue : borderColor, width: isPicked ? 1.5 : 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(topic, style: TextStyle(fontSize: 13, fontWeight: isPicked ? FontWeight.bold : FontWeight.w500, color: isPicked ? primaryBlue : textColor))),
                        Icon(isPicked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isPicked ? primaryBlue : subTextColor, size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => authC.lanjutKeFotoProfil(),
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Lanjut', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ] 
            else if (authC.registerStep.value == 2) ...[
              Text('Pasang Foto Profil', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22, color: textColor)),
              const SizedBox(height: 6),
              Text('Tambahkan foto profil agar teman-teman seniman lebih mudah mengenalimu.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 30),
              Center(child: CircleAvatar(radius: 54, backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person_outline_rounded, size: 58, color: primaryBlue))),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur unggah media galeri akan segera hadir!'), duration: Duration(seconds: 1)));
                  },
                  icon: const Icon(Icons.camera_alt_outlined, size: 18), label: const Text('Pilih Foto Profil'),
                  style: OutlinedButton.styleFrom(foregroundColor: primaryBlue, side: BorderSide(color: primaryBlue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => authC.selesaikanRegistrasi(emailController.text, usernameController.text, passwordController.text),
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Selesai & Muat Profil', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => authC.selesaikanRegistrasi(emailController.text, usernameController.text, passwordController.text),
                child: Text('Lewati untuk sekarang', style: TextStyle(color: subTextColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        );
      }),
    );
  }
}