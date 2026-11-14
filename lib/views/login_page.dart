// lib/views/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final bool isDarkMode;

  // Inisialisasi AuthController
  final AuthController authC = Get.put(AuthController());
  
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
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
        title: Text(
          'pusepuh',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: primaryBlue,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          Text(
            'Selamat Datang Kembali!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Silakan masuk untuk mengakses profil dan koleksi karya kamu.',
            style: TextStyle(fontSize: 13, color: subTextColor),
          ),
          const SizedBox(height: 24),
          
          // Membungkus pesan error dengan Obx agar reaktif
          Obx(() {
            if (authC.errorMessage.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authC.errorMessage.value,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          Text('Username atau Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: userController,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Masukkan username atau email...',
                hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
          const SizedBox(height: 6),
          
          // Membungkus TextField Password dengan Obx untuk fungsi hide/show
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: passwordController,
              obscureText: authC.obscurePassword.value,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Min. 8 digit (Huruf kapital, kecil & angka)',
                hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    authC.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: subTextColor,
                    size: 20,
                  ),
                  onPressed: () => authC.togglePasswordVisibility(),
                ),
              ),
            ),
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => authC.prosesLogin(userController.text.trim(), passwordController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Login', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum punya akun? ', style: TextStyle(fontSize: 13, color: subTextColor)),
              GestureDetector(
                onTap: () {
                  // Menggunakan Get.to pengganti Navigator.push
                  Get.to(() => RegisterPage(isDarkMode: isDarkMode));
                },
                child: Text('Daftar Sekarang', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}