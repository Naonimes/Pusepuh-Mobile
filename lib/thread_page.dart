import 'package:flutter/material.dart';

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
  
  late Map postData;
  late List commentList;
  String? replyingToUser;
  int? replyingToCommentId;

  @override
  void initState() {
    super.initState();
    postData = widget.threadInfo['post'] ?? {};
    if (postData['comments'] == null) {
      postData['comments'] = [];
    }
    commentList = postData['comments'];
    sortCommentsByLikes();
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
        const SnackBar(content: Text('Silakan login terlebih dahulu untuk berkomentar.')),
      );
    }
  }

  void kirimKomentar() {
    if (!widget.isLoggedIn) {
      tanganiLoginRequired();
      return;
    }

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
      
      postData['replies'] = commentList.length;
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          widget.threadInfo['threadName'] ?? 'Thread',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: bColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
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
                                    postData['userName'] ?? 'User',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                                  ),
                                  Text(
                                    postData['time'] ?? 'Baru saja',
                                    style: TextStyle(fontSize: 11, color: subTextColor),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        const SizedBox(height: 12),
                        Text(
                          postData['title'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          postData['caption'] ?? '',
                          style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor),
                        ),
                        if (postData['hasImage'] == true) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              postData['imageUrl'] ?? '',
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 16, color: primaryBlue),
                      const SizedBox(width: 6),
                      Text(
                        'Komentar (${commentList.length})',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (commentList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Belum ada komentar. Jadilah yang pertama berkomentar!',
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
              ),
            ),
            if (replyingToUser != null)
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