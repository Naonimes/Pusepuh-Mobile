// lib/views/thread_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/thread_controller.dart';
import '../controllers/auth_controller.dart';
import 'create_post_page.dart';
import 'post_card_widget.dart';

class ThreadPage extends StatelessWidget {
  final Map threadInfo;
  final bool isDarkMode;
  final Function(Map, bool) onFollowChanged;

  ThreadPage({
    super.key,
    required this.threadInfo,
    required this.isDarkMode,
    required this.onFollowChanged,
  }) {
    threadC.inisialisasiDataThread(threadInfo);
  }

  final ThreadController threadC = Get.put(ThreadController());
  final AuthController authC = Get.find<AuthController>();


  String ambilPembuatThread(Map threadItem) {
    if (threadItem['threadCreator'] != null && threadItem['threadCreator'].toString().isNotEmpty) {
      return threadItem['threadCreator'].toString();
    }
    if (threadItem['post'] != null && threadItem['post']['userName'] != null) {
      return threadItem['post']['userName'].toString();
    }
    return 'admin_pusepuh';
  }

  String ambilDeskripsiThread(Map threadItem) {
    if (threadItem['threadDescription'] != null && threadItem['threadDescription'].toString().isNotEmpty) {
      return threadItem['threadDescription'].toString();
    }
    String tName = (threadItem['threadName'] ?? '').toString().toLowerCase();
    String bType = (threadItem['boardType'] ?? 'Gallery').toString();

    if (tName.contains('kritik') || tName.contains('critique')) return 'Ruang diskusi untuk meminta kritik, saran konstruktif, dan evaluasi karya ilustrasi dari sesama seniman.';
    if (tName.contains('uma')) return 'Tempat berkumpulnya para penggemar dan ilustrator untuk membagikan fanart karakter Umamusume.';
    if (tName.contains('ibis')) return 'Pusat berbagi kode QR brush, tips, dan informasi update seputar aplikasi Ibis Paint X.';
    if (tName.contains('background') || tName.contains('scene')) return 'Komunitas khusus berbagi referensi dan karya ilustrasi latar belakang (background/scenery) ala anime.';
    if (tName.contains('showcase') || tName.contains('oc')) return 'Panggung pameran karya Original Character (OC) dan ilustrasi terbaikmu untuk diapresiasi bersama.';
    
    return 'Ruang komunitas di board $bType untuk berdiskusi dan berbagi karya seputar topik $tName.';
  }

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void tanganiLoginRequired(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Silakan login terlebih dahulu dari Beranda utama.')),
    );
  }

  void bukaFormTambahPostingan(BuildContext context) async {
    if (!authC.isLoggedIn.value) {
      tanganiLoginRequired(context);
      return;
    }

    final hasil = await Get.to(() => CreatePostPage(
          isDarkMode: isDarkMode,
          loggedInUser: authC.loggedInUser.value,
          initialThreadName: (threadInfo['threadName'] ?? '').toString(),
        ));

    if (hasil != null) {
      threadC.inisialisasiDataThread(threadInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    String bType = threadInfo['boardType'] ?? 'Gallery';
    Color bColor = getBoardColor(bType);
    bool isFollowed = threadInfo['isFollowed'] ?? false;
    String threadName = threadInfo['threadName'] ?? 'p/thread';
    String threadCreator = ambilPembuatThread(threadInfo);
    String threadDesc = ambilDeskripsiThread(threadInfo);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          threadName,
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16, color: bColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => bukaFormTambahPostingan(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  children: [
                    // Kotak Info Thread (Tombol Follow HANYA ADA DI SINI)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? bColor.withValues(alpha: 0.18) : bColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: bColor, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: bColor,
                                child: const Icon(Icons.tag, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: bColor, borderRadius: BorderRadius.circular(6)),
                                      child: Text('Board: $bType', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(threadName, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                                    Text('Dibuat oleh @$threadCreator', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: bColor)),
                                  ],
                                ),
                              ),
                              // Tombol Follow eksklusif di Thread Page
                              InkWell(
                                onTap: () {
                                  if (!authC.isLoggedIn.value) {
                                    tanganiLoginRequired(context);
                                    return;
                                  }
                                  threadInfo['isFollowed'] = !isFollowed;
                                  onFollowChanged(threadInfo, !isFollowed);
                                  threadC.allPosts.refresh();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isFollowed ? Colors.transparent : bColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: bColor),
                                  ),
                                  child: Text(isFollowed ? 'Following' : '+ Follow', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isFollowed ? bColor : Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(color: bColor.withValues(alpha: 0.3), height: 1),
                          const SizedBox(height: 10),
                          Text('Tentang Thread Ini:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: bColor)),
                          const SizedBox(height: 4),
                          Text(threadDesc, style: TextStyle(fontSize: 13, height: 1.4, color: textColor)),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Icon(Icons.dynamic_feed_rounded, size: 18, color: subTextColor),
                        const SizedBox(width: 6),
                        Text('Daftar Postingan (${threadC.allPosts.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (threadC.allPosts.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
                        child: Column(
                          children: [
                            Icon(Icons.post_add_rounded, size: 42, color: subTextColor),
                            const SizedBox(height: 8),
                            Text('Belum ada postingan di thread ini.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                            const SizedBox(height: 4),
                            Text('Jadilah yang pertama meramaikan diskusi dengan menekan tombol + Add Post di atas!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: subTextColor)),
                          ],
                        ),
                      )
                    else
                      ...List.generate(threadC.allPosts.length, (idx) {
                        var itemPost = threadC.allPosts[idx];

                        return GestureDetector(
                          onTap: () => threadC.pilihPostUntukKomentar(idx),
                          child: PostCardWidget(
                            threadItem: threadInfo,
                            post: itemPost,
                            isDarkMode: isDarkMode,
                            onUpvotePressed: () {
                              if (!authC.isLoggedIn.value) {
                                tanganiLoginRequired(context);
                                return;
                              }
                              threadC.toggleUpvote(itemPost);
                            },
                            onRepostPressed: () {
                              if (!authC.isLoggedIn.value) {
                                tanganiLoginRequired(context);
                                return;
                              }
                              threadC.toggleRepost(itemPost);
                            },
                            onReplyPressed: () {
                              threadC.pilihPostUntukKomentar(idx);
                              threadC.commentFocusNode.requestFocus();
                            },
                          ),
                        );
                      }),

                    // Daftar Komentar
                    if (threadC.allPosts.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 16, color: primaryBlue),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              threadC.allPosts.length > 1
                                  ? 'Komentar pada "${threadC.allPosts[threadC.activePostIndex.value]['title'] ?? 'Postingan'}" (${threadC.commentList.length})'
                                  : 'Komentar (${threadC.commentList.length})',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (threadC.commentList.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('Belum ada komentar di postingan ini. Yuk berkomentar!', style: TextStyle(color: subTextColor, fontSize: 13))),
                        )
                      else
                        ...threadC.commentList.map((c) {
                          bool isLiked = c['isLiked'] ?? false;
                          int likes = c['likes'] ?? 0;
                          List subReplies = c['replies'] ?? [];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(radius: 14, backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], child: Icon(Icons.person, size: 16, color: primaryBlue)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(c['userName'] ?? 'User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor)),
                                          const SizedBox(width: 6),
                                          Text('• ${c['time'] ?? ''}', style: TextStyle(fontSize: 10, color: subTextColor)),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (!authC.isLoggedIn.value) tanganiLoginRequired(context);
                                        else threadC.toggleLikeComment(c);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 16, color: isLiked ? Colors.redAccent : subTextColor),
                                          const SizedBox(width: 4),
                                          Text(likes.toString(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isLiked ? Colors.redAccent : subTextColor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(c['text'] ?? '', style: TextStyle(fontSize: 12.5, height: 1.4, color: textColor)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () {
                                    if (!authC.isLoggedIn.value) tanganiLoginRequired(context);
                                    else threadC.setReplyTo(c['userName'], c['id']);
                                  },
                                  child: Text('Reply', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryBlue)),
                                ),
                                if (subReplies.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  ...subReplies.map((r) => Container(
                                        margin: const EdgeInsets.only(top: 6, left: 16),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF262626) : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(r['userName'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textColor)),
                                                const SizedBox(width: 6),
                                                Text(r['time'] ?? '', style: TextStyle(fontSize: 9, color: subTextColor)),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(r['text'] ?? '', style: TextStyle(fontSize: 11.5, color: textColor)),
                                          ],
                                        ),
                                      )),
                                ],
                              ],
                            ),
                          );
                        }),
                    ],
                  ],
                ),
              ),

              // Bagian Kirim Komentar
              if (threadC.allPosts.isNotEmpty && threadC.replyingToUser.value != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  color: isDarkMode ? const Color(0xFF222222) : Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Membalas @${threadC.replyingToUser.value}', style: TextStyle(fontSize: 11, color: primaryBlue, fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () {
                          threadC.replyingToUser.value = null;
                          threadC.replyingToCommentId.value = null;
                        },
                        child: Icon(Icons.close_rounded, size: 16, color: subTextColor),
                      ),
                    ],
                  ),
                ),
              
              if (threadC.allPosts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: cardColor, border: Border(top: BorderSide(color: borderColor))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: threadC.commentController,
                          focusNode: threadC.commentFocusNode,
                          readOnly: !authC.isLoggedIn.value,
                          onTap: () {
                            if (!authC.isLoggedIn.value) tanganiLoginRequired(context);
                          },
                          style: TextStyle(color: textColor, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: threadC.replyingToUser.value != null ? 'Tulis balasan...' : 'Tulis komentar...',
                            hintStyle: TextStyle(color: subTextColor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (!authC.isLoggedIn.value) tanganiLoginRequired(context);
                          else threadC.kirimKomentar();
                        },
                        icon: Icon(Icons.send_rounded, color: primaryBlue),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}