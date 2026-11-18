// lib/views/board_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/board_controller.dart';
import 'thread_page.dart';
import 'create_thread_page.dart';

class BoardPage extends StatelessWidget {
  final String boardType;
  final bool isDarkMode;
  final List boardThreads;
  
  final bool isLoggedIn;
  final String loggedInUser;
  final VoidCallback? onLoginRequired;
  final Function(Map, bool)? onFollowChanged;

  BoardPage({
    super.key,
    required this.boardType,
    required this.isDarkMode,
    required this.boardThreads,
    this.isLoggedIn = false,
    this.loggedInUser = '',
    this.onLoginRequired,
    this.onFollowChanged,
  });

  // Inisialisasi BoardController
  final BoardController boardC = Get.put(BoardController());

  Color getBoardColor() {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void bukaFormTambahThread() async {
    if (!isLoggedIn) {
      if (onLoginRequired != null) {
        onLoginRequired!();
      }
      return;
    }

    // Menggunakan Get.to untuk navigasi
    final hasilThreadBaru = await Get.to(() => CreateThreadPage(
          isDarkMode: isDarkMode,
          loggedInUser: loggedInUser,
          initialBoard: boardType,
        ));

    if (hasilThreadBaru != null && hasilThreadBaru is Map) {
      if (hasilThreadBaru['boardType'] == boardType) {
        boardThreads.insert(0, hasilThreadBaru);
      }
      bukaHalamanThread(hasilThreadBaru);
    }
  }

  void bukaHalamanThread(Map threadItem) {
    Get.to(() => ThreadPage(
      threadInfo: threadItem,
      isDarkMode: isDarkMode,
      onFollowChanged: (updatedThread, status) {
        if (onFollowChanged != null) {
          onFollowChanged!(updatedThread, status);
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);
    Color bColor = getBoardColor();

    // Membungkus Scaffold dengan Obx untuk reaktivitas pencarian
    return Obx(() {
      List searchResults = [];
      if (boardC.searchQuery.value.isNotEmpty) {
        searchResults = boardThreads.where((t) {
          String tName = (t['threadName'] ?? '').toString().toLowerCase();
          String desc = boardC.ambilDeskripsiThread(t).toLowerCase();
          String query = boardC.searchQuery.value.toLowerCase();
          return tName.contains(query) || desc.contains(query);
        }).toList();
      }

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0.5,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            'Board: $boardType',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: bColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: bukaFormTambahThread,
                icon: Icon(Icons.add_circle_outline_rounded, size: 18, color: bColor),
                label: Text(
                  'Thread',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: bColor),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: boardC.searchController,
                onChanged: (val) => boardC.updateSearch(val),
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: subTextColor),
                  hintText: 'Cari thread di board $boardType...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  border: InputBorder.none,
                  suffixIcon: boardC.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18, color: subTextColor),
                          onPressed: () {
                            boardC.clearSearch();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),
            
            if (boardC.searchQuery.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text('Hasil Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: bColor)),
                    ),
                    if (searchResults.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text('Tidak ada hasil di board ini.', style: TextStyle(color: subTextColor, fontSize: 13)),
                      )
                    else
                      ...searchResults.map((t) => ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: bColor.withValues(alpha: 0.15),
                          child: Icon(Icons.tag, size: 16, color: bColor),
                        ),
                        title: Text(t['threadName'] ?? '', style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold)),
                        subtitle: Text(boardC.ambilDeskripsiThread(t), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: subTextColor, fontSize: 11)),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          boardC.clearSearch();
                          bukaHalamanThread(t);
                        },
                      )),
                  ],
                ),
              ),
              
            if (boardC.searchQuery.value.isEmpty) const SizedBox(height: 16),

            if (boardC.searchQuery.value.isEmpty && boardThreads.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Belum ada thread di Board ini.',
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ),
              )
            else if (boardC.searchQuery.value.isEmpty)
              ...boardThreads.map((threadItem) {
                bool isFollowed = threadItem['isFollowed'] ?? false;
                String threadName = threadItem['threadName'] ?? 'p/thread';
                String creator = boardC.ambilPembuatThread(threadItem);
                String threadDesc = boardC.ambilDeskripsiThread(threadItem);

                return InkWell(
                  onTap: () => bukaHalamanThread(threadItem),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        if (!isDarkMode)
                          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: bColor.withValues(alpha: 0.15),
                              child: Icon(Icons.tag, color: bColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    threadName,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Dibuat oleh @$creator',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: bColor),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (!isLoggedIn) {
                                  if (onLoginRequired != null) {
                                    onLoginRequired!();
                                  }
                                  return;
                                }
                                threadItem['isFollowed'] = !isFollowed;
                                if (onFollowChanged != null) {
                                  onFollowChanged!(threadItem, !isFollowed);
                                }
                                boardC.searchQuery.refresh(); // trick to update UI
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isFollowed ? Colors.transparent : primaryBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isFollowed ? subTextColor : primaryBlue),
                                ),
                                child: Text(
                                  isFollowed ? 'Following' : '+ Follow',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isFollowed ? subTextColor : primaryBlue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 8),
                        Text(
                          threadDesc,
                          style: TextStyle(fontSize: 12.5, color: subTextColor, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}