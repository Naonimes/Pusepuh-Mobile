// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import '../models/data_dummy.dart'; // Sesuaikan path jika data_dummy.dart dipindah ke /models

class AuthController extends GetxController {
  // Variabel reaktif (.obs) agar UI otomatis ter-update saat nilainya berubah
  var obscurePassword = true.obs;
  var errorMessage = ''.obs;
  
  var isLoggedIn = false.obs;
  var loggedInUser = ''.obs;
  var userTopics = [].obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validasiPassword(String pass) {
    if (pass.length < 8) return 'Password kurang dari 8 digit!';
    if (!pass.contains(RegExp(r'[A-Z]'))) return 'Password harus memiliki minimal 1 huruf kapital!';
    if (!pass.contains(RegExp(r'[a-z]'))) return 'Password harus memiliki minimal 1 huruf biasa (kecil)!';
    if (!pass.contains(RegExp(r'[0-9]'))) return 'Password harus memiliki minimal 1 angka!';
    return null;
  }

  void prosesLogin(String userInput, String passInput) {
    if (userInput.isEmpty) {
      errorMessage.value = 'Username atau Email tidak boleh kosong!';
      return;
    }

    String? passError = validasiPassword(passInput);
    if (passError != null) {
      errorMessage.value = passError;
      return;
    }

    // Menggunakan variabel databaseAkun dari data_dummy.dart
    Map<String, dynamic>? akunDitemukan;
    for (var akun in databaseAkun_103022400061) {
      if ((akun['username'] == userInput || akun['email'] == userInput) &&
          akun['password'] == passInput) {
        akunDitemukan = akun;
        break;
      }
    }

    if (akunDitemukan == null) {
      errorMessage.value = 'Username atau Password salah / akun belum terdaftar!';
      return;
    }

    // Jika sukses, simpan state dan kembali ke halaman sebelumnya
    errorMessage.value = ''; // Reset error
    isLoggedIn.value = true;
    loggedInUser.value = akunDitemukan['username'];
    userTopics.value = List.from(akunDitemukan['topics'] ?? []);
    
    Get.back(); // Pengganti Navigator.pop()
  }
}