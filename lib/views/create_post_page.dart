// lib/views/create_post_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/data_dummy.dart';
import '../controllers/creation_controllers.dart';

class CreatePostPage extends StatelessWidget {
  final bool isDarkMode;
  final String loggedInUser;
  final String? initialThreadName;

  CreatePostPage({
    super.key,
    required this.isDarkMode,
    required this.loggedInUser,
    this.initialThreadName,
  }) {
    createPostC.inisialisasi(initialThreadName);
  }

  final CreatePostController createPostC = Get.put(CreatePostController());

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50]!;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List threadNames = [];
    for (var t in masterThreads) {
      String tName = (t['threadName'] ?? '').toString();
      if (!threadNames.contains(tName)) threadNames.add(tName);
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Buat Postingan Baru', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 17, color: textColor)),
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Upload di Thread Mana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: threadNames.map((tName) {
                  bool isSelected = createPostC.selectedThreadName.value == tName;
                  return ChoiceChip(
                    label: Text(tName),
                    selected: isSelected,
                    selectedColor: primaryBlue,
                    backgroundColor: cardColor,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : textColor, fontWeight: FontWeight.bold, fontSize: 12),
                    onSelected: (val) => createPostC.ubahThread(tName),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Text('Judul Postingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: createPostC.titleController, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Tulis judul postingan yang menarik...', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
              const SizedBox(height: 18),
              Text('Caption', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: TextField(controller: createPostC.captionController, maxLines: 3, style: TextStyle(color: textColor, fontSize: 14), decoration: InputDecoration(hintText: 'Ceritakan detail karyamu atau pertanyaanmu di sini...', hintStyle: TextStyle(color: subTextColor, fontSize: 13), border: InputBorder.none))),
              const SizedBox(height: 18),
              Text('Pilih Opsi Media', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Row(
                children: createPostC.mediaTypes.map((mType) {
                  bool isSelected = createPostC.selectedMediaType.value == mType;
                  IconData iconData = Icons.text_fields_rounded;
                  if (mType == 'Gambar') iconData = Icons.image_outlined;
                  if (mType == 'Video') iconData = Icons.videocam_outlined;
                  if (mType == 'Lokasi') iconData = Icons.location_on_outlined;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => createPostC.ubahMediaType(mType),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(color: isSelected ? primaryBlue.withValues(alpha: 0.12) : cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? primaryBlue : borderColor)),
                        child: Column(
                          children: [
                            Icon(iconData, size: 20, color: isSelected ? primaryBlue : subTextColor),
                            const SizedBox(height: 4),
                            Text(mType, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? primaryBlue : subTextColor)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (createPostC.selectedMediaType.value != 'Teks') ...[
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload dari penyimpanan lokal segera hadir! Gunakan fitur Link di bawah untuk saat ini.'), duration: Duration(seconds: 2))),
                  child: Container(
                    width: double.infinity, height: 120,
                    decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.blue.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: primaryBlue.withValues(alpha: 0.5), width: 1.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 36, color: primaryBlue),
                        const SizedBox(height: 8),
                        Text('Drag and Drop ${createPostC.selectedMediaType.value} ke sini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryBlue)),
                        const SizedBox(height: 2),
                        Text('Atau klik untuk memilih dari perangkat (Segera Hadir)', style: TextStyle(fontSize: 11, color: subTextColor)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Upload Media via Link Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                  child: TextField(
                    controller: createPostC.linkController,
                    style: TextStyle(color: textColor, fontSize: 13),
                    decoration: InputDecoration(
                      icon: Icon(Icons.link_rounded, color: primaryBlue),
                      hintText: 'Paste link gambar di sini (https://...)',
                      hintStyle: TextStyle(color: subTextColor, fontSize: 12),
                      border: InputBorder.none,
                      suffixIcon: createPostC.currentLink.value.isNotEmpty ? IconButton(icon: Icon(Icons.clear, size: 18, color: subTextColor), onPressed: () => createPostC.clearLink()) : null,
                    ),
                  ),
                ),
                if (createPostC.currentLink.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Preview Media:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subTextColor)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      createPostC.currentLink.value, width: double.infinity, height: 190, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity, height: 120,
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.broken_image_outlined, size: 32, color: subTextColor), const SizedBox(height: 6), Text('Link media belum valid atau gagal dimuat', style: TextStyle(fontSize: 12, color: subTextColor))]),
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => createPostC.publikasikanPostingan(context),
                  icon: const Icon(Icons.send_rounded, size: 20), label: const Text('POST!'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}