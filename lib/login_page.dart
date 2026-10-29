import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final bool isDarkMode;

  const LoginPage({super.key, required this.isDarkMode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String? errorMessage;

  String? validasiPassword(String pass) {
    if (pass.length < 8) {
      return 'Password kurang dari 8 digit!';
    }
    if (!pass.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus memiliki minimal 1 huruf kapital!';
    }
    if (!pass.contains(RegExp(r'[a-z]'))) {
      return 'Password harus memiliki minimal 1 huruf biasa (kecil)!';
    }
    if (!pass.contains(RegExp(r'[0-9]'))) {
      return 'Password harus memiliki minimal 1 angka!';
    }
    return null;
  }

  void prosesLogin() {
    String userInput = userController.text.trim();
    String passInput = passwordController.text;

    if (userInput.isEmpty) {
      setState(() {
        errorMessage = 'Username atau Email tidak boleh kosong!';
      });
      return;
    }

    String? passError = validasiPassword(passInput);
    if (passError != null) {
      setState(() {
        errorMessage = passError;
      });
      return;
    }

    String cleanUsername = userInput.contains('@')
        ? userInput.split('@')[0].toLowerCase()
        : userInput;

    Navigator.pop(context, {
      'username': cleanUsername,
      'topics': <String>[],
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor =
        widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor =
        widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
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
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            'Username atau Email',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : Colors.grey[100],
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
          Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Min. 8 digit (Huruf kapital, kecil & angka)',
                hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: subTextColor,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: prosesLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun? ',
                style: TextStyle(fontSize: 13, color: subTextColor),
              ),
              GestureDetector(
                onTap: () async {
                  final hasilRegister = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                  if (hasilRegister != null && context.mounted) {
                    Navigator.pop(context, hasilRegister);
                  }
                },
                child: Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}