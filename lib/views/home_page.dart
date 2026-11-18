// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'board_page.dart';
import 'thread_page.dart';
import 'dm_page.dart';
import 'user_profile_page.dart';
import 'notification_page.dart';
import 'create_thread_page.dart';
import 'create_post_page.dart';
import 'post_card_widget.dart';
import '../models/data_dummy.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeC = Get.put(HomeController());
    final AuthController authC = Get.find<AuthController>();

    return Obx(() {
      Color bgColor = homeC.isDarkMode.value ? const Color(0xFF121212) : Colors.white;
      Color cardColor = homeC.isDarkMode.value ? const Color(0xFF1E1E1E) : Colors.white;
      Color textColor = homeC.isDarkMode.value ? Colors.white : Colors.black87;
      Color subTextColor = homeC.isDarkMode.value ? Colors.grey[400]! : Colors.grey[600]!;
      Color borderColor = homeC.isDarkMode.value ? Colors.grey[800]! : Colors.grey[200]!;
      Color primaryBlue = const Color(0xFF2563EB);

      void tampilkanPopupLogin() {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Column(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: primaryBlue.withValues(alpha: 0.12),
                    child: Icon(Icons.lock_person_rounded, color: primaryBlue, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text('Login ke Pusepuh', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                ],
              ),
              content: Text('Silakan login terlebih dahulu agar kami bisa memuat halaman profil dan berinteraksi penuh.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor)),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Get.to(() => LoginPage(isDarkMode: homeC.isDarkMode.value));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Get Started', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            );
          },
        );
      }

      void tampilkanPopupTambah() {
        if (!authC.isLoggedIn.value) {
          tampilkanPopupLogin();
          return;
        }
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Mulai Berkarya', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pilih jenis konten yang ingin kamu bagikan ke komunitas Pusepuh:', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: subTextColor)),
                  const SizedBox(height: 18),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryBlue.withValues(alpha: 0.4))),
                    leading: CircleAvatar(backgroundColor: primaryBlue.withValues(alpha: 0.12), child: Icon(Icons.forum_outlined, color: primaryBlue)),
                    title: Text('Buat Thread Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                    subtitle: Text('Buka ruang diskusi baru (p/thread)', style: TextStyle(fontSize: 11, color: subTextColor)),
                    onTap: () {
                      Navigator.pop(dialogContext);
                      Get.to(() => CreateThreadPage(isDarkMode: homeC.isDarkMode.value, loggedInUser: authC.loggedInUser.value));
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green.withValues(alpha: 0.4))),
                    leading: CircleAvatar(backgroundColor: Colors.green.withValues(alpha: 0.12), child: const Icon(Icons.post_add_rounded, color: Colors.green)),
                    title: Text('Buat Postingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                    subtitle: Text('Upload karya atau pertanyaan ke thread', style: TextStyle(fontSize: 11, color: subTextColor)),
                    onTap: () {
                      Navigator.pop(dialogContext);
                      Get.to(() => CreatePostPage(isDarkMode: homeC.isDarkMode.value, loggedInUser: authC.loggedInUser.value));
                    },
                  ),
                ],
              ),
            );
          },
        );
      }

      Color getBoardColor(String? boardType) {
        if (boardType == 'Asking') return Colors.redAccent;
        if (boardType == 'Info') return Colors.amber[700]!;
        return Colors.green;
      }

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0.5,
          leading: IconButton(
            onPressed: () => Get.to(() => DmPage(isDarkMode: homeC.isDarkMode.value)),
            icon: Icon(Icons.mail_outline_rounded, color: primaryBlue),
          ),
          centerTitle: true,
          title: Text(
            'pusepuh',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5, color: primaryBlue),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (!authC.isLoggedIn.value) {
                  tampilkanPopupLogin();
                } else {
                  Get.to(() => NotificationPage(isDarkMode: homeC.isDarkMode.value));
                }
              },
              icon: Icon(Icons.notifications_none_rounded, color: homeC.isDarkMode.value ? Colors.white : Colors.black87),
            ),
            IconButton(
              onPressed: () => homeC.toggleTheme(),
              icon: Icon(homeC.isDarkMode.value ? Icons.light_mode : Icons.dark_mode_outlined, color: homeC.isDarkMode.value ? Colors.amber : Colors.black87),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: homeC.selectedBottomNav.value == 2 && authC.isLoggedIn.value
            ? ProfilePage(
                userName: authC.loggedInUser.value,
                isDarkMode: homeC.isDarkMode.value,
                selectedTopics: authC.userTopics,
                onLogout: () {
                  authC.isLoggedIn.value = false;
                  authC.loggedInUser.value = '';
                  homeC.ubahBottomNav(0);
                  tampilkanPopupLogin();
                },
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: homeC.isDarkMode.value ? const Color(0xFF2C2C2C) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: homeC.searchController,
                      onChanged: (val) => homeC.updateSearch(val),
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: subTextColor),
                        hintText: 'Cari topik atau thread...',
                        hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                        border: InputBorder.none,
                        suffixIcon: homeC.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, size: 18, color: subTextColor),
                                onPressed: () {
                                  homeC.clearSearch();
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  if (homeC.searchQuery.value.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text('Hasil Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryBlue)),
                          ),
                          if (homeC.searchResults.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text('Thread tidak ditemukan.', style: TextStyle(color: subTextColor, fontSize: 13)),
                            )
                          else
                            ...homeC.searchResults.map((t) => ListTile(
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: getBoardColor(t['boardType']).withValues(alpha: 0.15),
                                child: Icon(Icons.tag, size: 16, color: getBoardColor(t['boardType'])),
                              ),
                              title: Text(t['threadName'] ?? '', style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: Text(t['post']['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: subTextColor, fontSize: 11)),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                homeC.clearSearch();
                                Get.to(() => ThreadPage(
                                  threadInfo: t,
                                  isDarkMode: homeC.isDarkMode.value,
                                  onFollowChanged: (th, s) => homeC.toggleFollow(th),
                                ));
                              },
                            )),
                        ],
                      ),
                    ),

                  if (homeC.searchQuery.value.isEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton.icon(
                          onPressed: () => Get.to(() => BoardPage(boardType: 'Gallery', isDarkMode: homeC.isDarkMode.value, boardThreads: masterThreads.where((th) => th['boardType'] == 'Gallery').toList(), isLoggedIn: authC.isLoggedIn.value, loggedInUser: authC.loggedInUser.value, onLoginRequired: tampilkanPopupLogin, onFollowChanged: (th, s) => homeC.toggleFollow(th))),
                          icon: const Icon(Icons.image_outlined, size: 16), label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: ElevatedButton.icon(
                          onPressed: () => Get.to(() => BoardPage(boardType: 'Asking', isDarkMode: homeC.isDarkMode.value, boardThreads: masterThreads.where((th) => th['boardType'] == 'Asking').toList(), isLoggedIn: authC.isLoggedIn.value, loggedInUser: authC.loggedInUser.value, onLoginRequired: tampilkanPopupLogin, onFollowChanged: (th, s) => homeC.toggleFollow(th))),
                          icon: const Icon(Icons.help_outline, size: 16), label: const Text('Asking'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: ElevatedButton.icon(
                          onPressed: () => Get.to(() => BoardPage(boardType: 'Info', isDarkMode: homeC.isDarkMode.value, boardThreads: masterThreads.where((th) => th['boardType'] == 'Info').toList(), isLoggedIn: authC.isLoggedIn.value, loggedInUser: authC.loggedInUser.value, onLoginRequired: tampilkanPopupLogin, onFollowChanged: (th, s) => homeC.toggleFollow(th))),
                          icon: const Icon(Icons.campaign_outlined, size: 16), label: const Text('Info'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                        )),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderColor, width: 1.5))),
                      child: Row(
                        children: List.generate(homeC.feedTabs.length, (index) {
                          bool isSelected = homeC.selectedFeedTab.value == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => homeC.ubahFeedTab(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? primaryBlue : Colors.transparent, width: 3))),
                                child: Text(homeC.feedTabs[index], textAlign: TextAlign.center, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 14, color: isSelected ? primaryBlue : subTextColor)),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (homeC.feedItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(homeC.selectedFeedTab.value == 1 ? 'Belum ada thread yang kamu follow.\nYuk follow thread di board pilihanmu!' : 'Tidak ada postingan.', textAlign: TextAlign.center, style: TextStyle(color: subTextColor, fontSize: 13)),
                        ),
                      )
                    else
                      ...homeC.feedItems.map((item) {
                        Map threadItem = item['thread'];
                        Map post = item['post'];

                        return PostCardWidget(
                          threadItem: threadItem,
                          post: post,
                          isDarkMode: homeC.isDarkMode.value,
                          onUpvotePressed: () {
                            if (!authC.isLoggedIn.value) {
                              tampilkanPopupLogin();
                              return;
                            }
                            bool isUp = post['isUpvoted'] ?? false;
                            int upvotes = post['upvotes'] ?? 0;
                            post['isUpvoted'] = !isUp;
                            post['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
                            homeC.searchQuery.refresh();
                          },
                          onRepostPressed: () {
                            if (!authC.isLoggedIn.value) {
                              tampilkanPopupLogin();
                              return;
                            }
                            post['isReposted'] = !(post['isReposted'] ?? false);
                            homeC.searchQuery.refresh();
                          },
                          onReplyPressed: () => Get.to(() => ThreadPage(
                                threadInfo: threadItem,
                                isDarkMode: homeC.isDarkMode.value,
                                onFollowChanged: (th, s) => homeC.toggleFollow(th),
                              )),
                        );
                      }),
                  ],
                ],
              ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(top: BorderSide(color: borderColor, width: 1)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => homeC.ubahBottomNav(0),
                  icon: Icon(Icons.home_filled, size: 28, color: homeC.selectedBottomNav.value == 0 ? (homeC.isDarkMode.value ? Colors.white : Colors.black) : subTextColor),
                ),
                GestureDetector(
                  onTap: tampilkanPopupTambah,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 26, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  // REVISI 1: Bottom bar profile memunculkan popup login jika belum login
                  onTap: () => homeC.ubahBottomNav(2, onLoginRequired: tampilkanPopupLogin),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: homeC.selectedBottomNav.value == 2 ? primaryBlue : subTextColor,
                    child: const Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}