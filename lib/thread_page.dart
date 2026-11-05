import 'package:flutter/material.dart';
import 'create_post_page.dart';

class ThreadPage extends StatefulWidget {
  final Map threadInfo;
  final bool isDarkMode;
  final bool isLoggedIn;
  final String loggedInUser;
  final VoidCallback? onLoginRequired;
  final Function(Map, bool) onFollowChanged;

  const ThreadPage({
    super.key,
    required this.threadInfo,
    required this.isDarkMode,
    this.isLoggedIn = false,
    this.loggedInUser = '',
    this.onLoginRequired,
    required this.onFollowChanged,
  });

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  
  late List allPosts;
  int activePostIndex = 0;
  Map? activePostData;
  List commentList = [];
  String? replyingToUser;
  int? replyingToCommentId;

  @override
  void initState() {
    super.initState();
    segarkanDataThread();
  }

  void segarkanDataThread() {
    if (widget.threadInfo['posts'] == null) {
      if (widget.threadInfo['post'] != null) {
        widget.threadInfo['posts'] = [widget.threadInfo['post']];
      } else {
        widget.threadInfo['posts'] = [];
      }
    }
    allPosts = widget.threadInfo['posts'];
    if (allPosts.isNotEmpty) {
      if (activePostIndex >= allPosts.length) {
        activePostIndex = 0;
      }
      activePostData = allPosts[activePostIndex];
      if (activePostData!['comments'] == null) {
        activePostData!['comments'] = [];
      }
      commentList = activePostData!['comments'];
      sortCommentsByLikes();
    } else {
      activePostData = null;
      commentList = [];
    }
  }

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

    if (tName.contains('kritik') || tName.contains('critique')) {
      return 'Ruang diskusi untuk meminta kritik, saran konstruktif, dan evaluasi karya ilustrasi dari sesama seniman.';
    }
    if (tName.contains('uma')) {
      return 'Tempat berkumpulnya para penggemar dan ilustrator untuk membagikan fanart karakter Umamusume.';
    }
    if (tName.contains('ibis')) {
      return 'Pusat berbagi kode QR brush, tips, dan informasi update seputar aplikasi Ibis Paint X.';
    }
    if (tName.contains('background') || tName.contains('scene')) {
      return 'Komunitas khusus berbagi referensi dan karya ilustrasi latar belakang (background/scenery) ala anime.';
    }
    if (tName.contains('showcase') || tName.contains('oc')) {
      return 'Panggung pameran karya Original Character (OC) dan ilustrasi terbaikmu untuk diapresiasi bersama.';
    }
    return 'Ruang komunitas di board $bType untuk berdiskusi dan berbagi karya seputar topik $tName.';
  }

  void pilihPostUntukKomentar(int index) {
    if (allPosts.isEmpty) return;
    setState(() {
      activePostIndex = index;
      activePostData = allPosts[activePostIndex];
      if (activePostData!['comments'] == null) {
        activePostData!['comments'] = [];
      }
      commentList = activePostData!['comments'];
      replyingToUser = null;
      replyingToCommentId = null;
      sortCommentsByLikes();
    });
  }

  void sortCommentsByLikes() {
    commentList.sort((a, b) {
      int likesA = a['likes'] ?? 0;
      int likesB = b['likes'] ?? 0;
      return likesB.compareTo(likesA);
    });
  }

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void tanganiLoginRequired() {
    if (widget.onLoginRequired != null) {
      widget.onLoginRequired!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu dari Beranda utama.')),
      );
    }
  }

  void bukaFormTambahPostingan() async {
    if (!widget.isLoggedIn) {
      tanganiLoginRequired();
      return;
    }

    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostPage(
          isDarkMode: widget.isDarkMode,
          loggedInUser: widget.loggedInUser,
          initialThreadName: (widget.threadInfo['threadName'] ?? '').toString(),
        ),
      ),
    );

    if (hasil != null) {
      setState(() {
        activePostIndex = 0;
        segarkanDataThread();
      });
    }
  }

  void kirimKomentar() {
    if (!widget.isLoggedIn) {
      tanganiLoginRequired();
      return;
    }
    if (activePostData == null) return;

    String text = commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (replyingToUser != null && replyingToCommentId != null) {
        for (var c in commentList) {
          if (c['id'] == replyingToCommentId) {
            c['replies'] = c['replies'] ?? [];
            c['replies'].add({
              'userName': widget.loggedInUser,
              'text': text,
              'time': 'Baru saja',
              'likes': 0,
              'isLiked': false,
            });
            break;
          }
        }
      } else {
        commentList.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'userName': widget.loggedInUser,
          'time': 'Baru saja',
          'text': text,
          'likes': 0,
          'isLiked': false,
          'replies': [],
        });
      }
      
      activePostData!['replies'] = commentList.length;
      sortCommentsByLikes();
      commentController.clear();
      replyingToUser = null;
      replyingToCommentId = null;
    });
    FocusScope.of(context).unfocus();
  }

  void toggleLikeComment(Map comment) {
    if (!widget.isLoggedIn) {
      tanganiLoginRequired();
      return;
    }

    setState(() {
      bool isLiked = comment['isLiked'] ?? false;
      int likes = comment['likes'] ?? 0;
      comment['isLiked'] = !isLiked;
      comment['likes'] = isLiked ? likes - 1 : likes + 1;
      sortCommentsByLikes();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    String bType = widget.threadInfo['boardType'] ?? 'Gallery';
    Color bColor = getBoardColor(bType);
    bool isFollowed = widget.threadInfo['isFollowed'] ?? false;
    String threadName = widget.threadInfo['threadName'] ?? 'p/thread';
    String threadCreator = ambilPembuatThread(widget.threadInfo);
    String threadDesc = ambilDeskripsiThread(widget.threadInfo);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          threadName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: bColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: bukaFormTambahPostingan,
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? bColor.withValues(alpha: 0.18) : bColor.withValues(alpha: 0.1),
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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: bColor,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Board: $bType',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    threadName,
                                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
                                  ),
                                  Text(
                                    'Dibuat oleh @$threadCreator',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: bColor),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (!widget.isLoggedIn) {
                                  tanganiLoginRequired();
                                  return;
                                }
                                setState(() {
                                  widget.threadInfo['isFollowed'] = !isFollowed;
                                  widget.onFollowChanged(widget.threadInfo, !isFollowed);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isFollowed ? Colors.transparent : bColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: bColor),
                                ),
                                child: Text(
                                  isFollowed ? 'Following' : '+ Follow',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isFollowed ? bColor : Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: bColor.withValues(alpha: 0.3), height: 1),
                        const SizedBox(height: 10),
                        Text(
                          'Tentang Thread Ini:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: bColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          threadDesc,
                          style: TextStyle(fontSize: 13, height: 1.4, color: textColor),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Icon(Icons.dynamic_feed_rounded, size: 18, color: subTextColor),
                      const SizedBox(width: 6),
                      Text(
                        'Daftar Postingan (${allPosts.length})',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (allPosts.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.post_add_rounded, size: 42, color: subTextColor),
                          const SizedBox(height: 8),
                          Text(
                            'Belum ada postingan di thread ini.',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jadilah yang pertama meramaikan diskusi dengan menekan tombol + Add Post di atas!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: subTextColor),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(allPosts.length, (idx) {
                      var itemPost = allPosts[idx];
                      bool isReposted = itemPost['isReposted'] ?? false;
                      bool isSelectedPost = activePostIndex == idx;

                      return GestureDetector(
                        onTap: () => pilihPostUntukKomentar(idx),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelectedPost && allPosts.length > 1 ? primaryBlue : borderColor,
                              width: isSelectedPost && allPosts.length > 1 ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Icon(Icons.person_outline_rounded, size: 22, color: subTextColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemPost['userName'] ?? 'User',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                                        ),
                                        Text(
                                          itemPost['time'] ?? 'Baru saja',
                                          style: TextStyle(fontSize: 11, color: subTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                itemPost['title'] ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                itemPost['caption'] ?? '',
                                style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor),
                              ),
                              if (itemPost['hasImage'] == true) ...[
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    itemPost['imageUrl'] ?? '',
                                    width: double.infinity,
                                    height: 190,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 190,
                                        color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                        child: Icon(Icons.broken_image_outlined, color: subTextColor),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Divider(color: borderColor, height: 1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!widget.isLoggedIn) {
                                        tanganiLoginRequired();
                                        return;
                                      }
                                      setState(() {
                                        bool isUp = itemPost['isUpvoted'] ?? false;
                                        int upvotes = itemPost['upvotes'] ?? 0;
                                        itemPost['isUpvoted'] = !isUp;
                                        itemPost['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
                                      });
                                    },
                                  child: Row(
                                      children: [
                                        Icon(Icons.arrow_upward_rounded, size: 18, color: (itemPost['isUpvoted'] ?? false) ? primaryBlue : subTextColor),
                                        const SizedBox(width: 4),
                                        Text('Up (${itemPost['upvotes'] ?? 0})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: (itemPost['isUpvoted'] ?? false) ? primaryBlue : subTextColor)),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pilihPostUntukKomentar(idx);
                                      commentFocusNode.requestFocus();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline_rounded, size: 17, color: isSelectedPost ? primaryBlue : subTextColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${itemPost['replies'] ?? 0} Reply',
                                          style: TextStyle(fontSize: 12, fontWeight: isSelectedPost ? FontWeight.bold : FontWeight.normal, color: isSelectedPost ? primaryBlue : subTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (!widget.isLoggedIn) {
                                        tanganiLoginRequired();
                                        return;
                                      }
                                      setState(() {
                                        itemPost['isReposted'] = !isReposted;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.repeat_rounded, size: 18, color: isReposted ? Colors.green : subTextColor),
                                        const SizedBox(width: 4),
                                        Text('Repost', style: TextStyle(fontSize: 12, color: isReposted ? Colors.green : subTextColor)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.share_outlined, size: 18, color: subTextColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  if (activePostData != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 16, color: primaryBlue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            allPosts.length > 1
                                ? 'Komentar pada "${activePostData!['title'] ?? 'Postingan'}" (${commentList.length})'
                                : 'Komentar (${commentList.length})',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (commentList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Belum ada komentar di postingan ini. Yuk berkomentar!',
                            style: TextStyle(color: subTextColor, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ...commentList.map((c) {
                        bool isLiked = c['isLiked'] ?? false;
                        int likes = c['likes'] ?? 0;
                        List subReplies = c['replies'] ?? [];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Icon(Icons.person, size: 16, color: primaryBlue),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          c['userName'] ?? 'User',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '• ${c['time'] ?? ''}',
                                          style: TextStyle(fontSize: 10, color: subTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => toggleLikeComment(c),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                          size: 16,
                                          color: isLiked ? Colors.redAccent : subTextColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          likes.toString(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isLiked ? Colors.redAccent : subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c['text'] ?? '',
                                style: TextStyle(fontSize: 12.5, height: 1.4, color: textColor),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () {
                                  if (!widget.isLoggedIn) {
                                    tanganiLoginRequired();
                                    return;
                                  }
                                  setState(() {
                                    replyingToUser = c['userName'];
                                    replyingToCommentId = c['id'];
                                  });
                                  commentFocusNode.requestFocus();
                                },
                                child: Text(
                                  'Reply',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                              if (subReplies.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                ...subReplies.map((r) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 6, left: 16),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: widget.isDarkMode ? const Color(0xFF262626) : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              r['userName'] ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textColor),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              r['time'] ?? '',
                                              style: TextStyle(fontSize: 9, color: subTextColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          r['text'] ?? '',
                                          style: TextStyle(fontSize: 11.5, color: textColor),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        );
                      }),
                  ],
                ],
              ),
            ),
            if (activePostData != null && replyingToUser != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: widget.isDarkMode ? const Color(0xFF222222) : Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Membalas @$replyingToUser',
                      style: TextStyle(fontSize: 11, color: primaryBlue, fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          replyingToUser = null;
                          replyingToCommentId = null;
                        });
                      },
                      child: Icon(Icons.close_rounded, size: 16, color: subTextColor),
                    ),
                  ],
                ),
              ),
            if (activePostData != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        focusNode: commentFocusNode,
                        readOnly: !widget.isLoggedIn,
                        onTap: () {
                          if (!widget.isLoggedIn) {
                            tanganiLoginRequired();
                          }
                        },
                        style: TextStyle(color: textColor, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: replyingToUser != null ? 'Tulis balasan...' : 'Tulis komentar...',
                          hintStyle: TextStyle(color: subTextColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: kirimKomentar,
                      icon: Icon(Icons.send_rounded, color: primaryBlue),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}