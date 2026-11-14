import 'package:flutter/material.dart';
import 'data_dummy.dart';

class CreatePostPage extends StatefulWidget {
  final bool isDarkMode;
  final String loggedInUser;
  final String? initialThreadName;

  const CreatePostPage({
    super.key,
    required this.isDarkMode,
    required this.loggedInUser,
    this.initialThreadName,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  late String selectedThreadName;
  String selectedMediaType = 'Gambar';
  final List mediaTypes = ['Teks', 'Gambar', 'Video', 'Lokasi'];

  @override
  void initState() {
    super.initState();
    if (widget.initialThreadName != null && widget.initialThreadName!.isNotEmpty) {
      selectedThreadName = widget.initialThreadName!;
    } else if (masterThreads.isNotEmpty) {
      selectedThreadName = (masterThreads[0]['threadName'] ?? 'p/umamusume').toString();
    } else {
      selectedThreadName = 'p/umum';
    }
  }

  void publikasikanPostingan_103022400061() {
    String title = titleController.text.trim();
    String cap = captionController.text.trim();
    String link = linkController.text.trim();

    if (title.isEmpty || cap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan caption postingan wajib diisi!')),
      );
      return;
    }

    bool pakeGambar = (selectedMediaType != 'Teks') && link.isNotEmpty;

    Map newPost = {
      'userName': widget.loggedInUser,
      'time': 'Baru saja',
      'title': title,
      'caption': cap,
      'hasImage': pakeGambar,
      'imageUrl': pakeGambar ? link : '',
      'mediaType': selectedMediaType,
      'upvotes': 0,
      'isUpvoted': false,
      'replies': 0,
      'isReposted': false,
      'comments': [],
    };

    Map? targetThread;
    for (var t in masterThreads) {
      if (t['threadName'] == selectedThreadName) {
        targetThread = t;
        break;
      }
    }

    if (targetThread != null) {
      if (targetThread['posts'] == null) {
        targetThread['posts'] = [targetThread['post']];
      }
      targetThread['posts'].insert(0, newPost);
    }

    Navigator.pop(context, targetThread);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50]!;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List threadNames = [];
    for (var t in masterThreads) {
      String tName = (t['threadName'] ?? '').toString();
      if (!threadNames.contains(tName)) {
        threadNames.add(tName);
      }
    }

    String currentLink = linkController.text.trim();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Buat Postingan Baru',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 17, color: textColor),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Upload di Thread Mana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: threadNames.map((tName) {
                bool isSelected = selectedThreadName == tName;
                return ChoiceChip(
                  label: Text(tName),
                  selected: isSelected,
                  selectedColor: primaryBlue,
                  backgroundColor: cardColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    setState(() {
                      selectedThreadName = tName;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text('Judul Postingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: titleController,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tulis judul postingan yang menarik...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Caption', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: captionController,
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Ceritakan detail karyamu atau pertanyaanmu di sini...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Pilih Opsi Media', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Row(
              children: mediaTypes.map((mType) {
                bool isSelected = selectedMediaType == mType;
                IconData iconData = Icons.text_fields_rounded;
                if (mType == 'Gambar') iconData = Icons.image_outlined;
                if (mType == 'Video') iconData = Icons.videocam_outlined;
                if (mType == 'Lokasi') iconData = Icons.location_on_outlined;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMediaType = mType;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryBlue.withValues(alpha: 0.12) : cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? primaryBlue : borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(iconData, size: 20, color: isSelected ? primaryBlue : subTextColor),
                          const SizedBox(height: 4),
                          Text(
                            mType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? primaryBlue : subTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (selectedMediaType != 'Teks') ...[
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload dari penyimpanan lokal segera hadir! Gunakan fitur Link di bawah untuk saat ini.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.blue.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryBlue.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 36, color: primaryBlue),
                      const SizedBox(height: 8),
                      Text(
                        'Drag and Drop $selectedMediaType ke sini',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryBlue),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Atau klik untuk memilih dari perangkat (Segera Hadir)',
                        style: TextStyle(fontSize: 11, color: subTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Upload Media via Link Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: linkController,
                  onChanged: (val) {
                    setState(() {});
                  },
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    icon: Icon(Icons.link_rounded, color: primaryBlue),
                    hintText: 'Paste link gambar di sini (https://...)',
                    hintStyle: TextStyle(color: subTextColor, fontSize: 12),
                    border: InputBorder.none,
                    suffixIcon: currentLink.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 18, color: subTextColor),
                            onPressed: () {
                              linkController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
              if (currentLink.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Preview Media:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subTextColor)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentLink,
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_outlined, size: 32, color: subTextColor),
                            const SizedBox(height: 6),
                            Text('Link media belum valid atau gagal dimuat', style: TextStyle(fontSize: 12, color: subTextColor)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: publikasikanPostingan_103022400061,
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text('POST!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}