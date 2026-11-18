// lib/views/create_thread_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/creation_controllers.dart';

class CreateThreadPage extends StatelessWidget {
  final bool isDarkMode;
  final String loggedInUser;
  final String? initialBoard;

  CreateThreadPage({
    super.key,
    required this.isDarkMode,
    required this.loggedInUser,
    this.initialBoard,
  }) {
    createThreadC.inisialisasi(initialBoard);
  }

  final CreateThreadController createThreadC = Get.put(CreateThreadController());

  Color getBoardColor(String bType) {
    if (bType == 'Asking') return Colors.redAccent;
    if (bType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50]!;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    Color primaryBlue = const Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Buat Thread Baru', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 17, color: textColor)),
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Nama Thread', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                child: Row(
                  children: [
                    Text('p/', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryBlue)),
                    const SizedBox(width: 4),
                    Expanded(child: TextField(controller: createThreadC.nameController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'contoh: anatomi_dasar', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Pilih Kategori Board', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Row(
                children: createThreadC.boards.map((b) {
                  bool isSelected = createThreadC.selectedBoard.value == b;
                  Color bCol = getBoardColor(b);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => createThreadC.ubahBoard(b),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: isSelected ? bCol : cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? bCol : borderColor)),
                        child: Center(child: Text(b, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? Colors.white : textColor))),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Caption / Deskripsi Thread', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: createThreadC.captionController, maxLines: 4, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Jelaskan fungsi atau aturan dari thread ini...', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => createThreadC.buatThreadBaru(context),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 22), label: const Text('ADD THREAD'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}