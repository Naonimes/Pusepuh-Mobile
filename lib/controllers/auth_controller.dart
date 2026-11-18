// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import '../models/data_dummy.dart';

class AuthController extends GetxController {
  // --- Variabel State Login ---
  var obscurePassword = true.obs;
  var errorMessage = ''.obs;
  var isLoggedIn = false.obs;
  var loggedInUser = ''.obs;
  var userTopics = <String>[].obs;

  // --- Variabel State Registrasi ---
  var registerStep = 0.obs;
  var obscureConfirm = true.obs;
  var chosenTopics = <String>[].obs;
  var registerError = ''.obs;

  // --- Fungsi Form Login ---
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmVisibility() {
    obscureConfirm.value = !obscureConfirm.value;
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

    errorMessage.value = '';
    isLoggedIn.value = true;
    loggedInUser.value = akunDitemukan['username'];
    userTopics.value = List<String>.from(akunDitemukan['topics'] ?? []);
    Get.back();
  }

  // --- Fungsi Form Registrasi ---
  String? validasiUsername(String user) {
    if (user.isEmpty) return 'Username tidak boleh kosong!';
    if (user.contains(' ')) return 'Username tidak boleh mengandung spasi!';
    if (user != user.toLowerCase()) return 'Username tidak boleh memakai huruf kapital!';
    if (!RegExp(r'^[a-z0-9_.]+$').hasMatch(user)) {
      return 'Username hanya boleh berisi huruf kecil, angka, titik, atau underscore!';
    }
    bool sudahTerpakai = databaseAkun_103022400061.any((akun) => akun['username'] == user);
    if (sudahTerpakai) return 'Username ini sudah dipakai, coba nama lain!';
    return null;
  }

  void lanjutKeTopik(String email, String user, String pass, String confirmPass) {
    if (email.isEmpty || !email.contains('@')) {
      registerError.value = 'Masukkan alamat email yang valid!';
      return;
    }

    String? errorUser = validasiUsername(user);
    if (errorUser != null) {
      registerError.value = errorUser;
      return;
    }

    String? errorPass = validasiPassword(pass);
    if (errorPass != null) {
      registerError.value = errorPass;
      return;
    }

    if (pass != confirmPass) {
      registerError.value = 'Konfirmasi password tidak cocok!';
      return;
    }

    registerError.value = '';
    registerStep.value = 1;
  }

  void toggleTopicSelection(String topic) {
    if (chosenTopics.contains(topic)) {
      chosenTopics.remove(topic);
    } else {
      chosenTopics.add(topic);
    }
  }

  void lanjutKeFotoProfil() {
    if (chosenTopics.isEmpty) {
      registerError.value = 'Pilih minimal 1 topik yang kamu minati!';
      return;
    }
    registerError.value = '';
    registerStep.value = 2;
  }

  void selesaikanRegistrasi(String email, String user, String pass) {
    // Tambahkan data akun baru ke data_dummy (database lokal sementara)
    databaseAkun_103022400061.add({
      'email': email.trim(),
      'username': user.trim(),
      'password': pass,
      'topics': List<String>.from(chosenTopics),
    });

    // Otomatis login dengan akun yang baru dibuat
    isLoggedIn.value = true;
    loggedInUser.value = user.trim();
    userTopics.value = List<String>.from(chosenTopics);
    
    // Reset state form registrasi
    registerStep.value = 0;
    chosenTopics.clear();
    registerError.value = '';

    // Gunakan Get.offAll() agar tidak bisa di-back ke halaman registrasi/login lagi
    Get.offAllNamed('/home'); 
  }

  void resetRegisterState() {
    registerStep.value = 0;
    chosenTopics.clear();
    registerError.value = '';
    obscureConfirm.value = true;
  }
}