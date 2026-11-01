import 'package:flutter/material.dart';

class ThreadPage extends StatefulWidget {
  final Map threadInfo;
  final bool isDarkMode;
  final Function(Map, bool) onFollowChanged;

  const ThreadPage({
    super.key,
    required this.threadInfo,
    required this.isDarkMode,
    required this.onFollowChanged,
  });

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') {
      return Colors.redAccent;
    } else if (boardType == 'Info') {
      return Colors.amber[700]!;
    } else {
      return Colors.green;
    }
  }

  void bukaFullscreenGambar(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: imageUrl,
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor =
        widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor =
        widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    String bType = widget.threadInfo['boardType'] ?? 'Gallery';
    Color themeColor = getBoardColor(bType);
    var post = widget.threadInfo['post'] ?? {};
    bool isFollowed = widget.threadInfo['isFollowed'] ?? false;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        title: Text(
          widget.threadInfo['threadName'] ?? 'Thread',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: themeColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: themeColor, width: 1.5),
              boxShadow: [
                if (!widget.isDarkMode)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.forum_rounded,
                              color: themeColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.threadInfo['threadName'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.threadInfo['isFollowed'] = !isFollowed;
                        });
                        widget.onFollowChanged(
                            widget.threadInfo, !isFollowed);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isFollowed
                              ? Colors.transparent
                              : themeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isFollowed ? subTextColor : themeColor,
                          ),
                        ),
                        child: Text(
                          isFollowed ? 'Following' : '+ Follow',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isFollowed ? subTextColor : themeColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.threadInfo['threadDesc'] ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: subTextColor,
                  ),
                ),
                const SizedBox(height: 14),
                Divider(color: borderColor, height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dibuat oleh: @${widget.threadInfo['threadCreator'] ?? 'admin'}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: themeColor,
                      ),
                    ),
                    Text(
                      'Tanggal: ${widget.threadInfo['threadDate'] ?? ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Postingan Warga di Thread Ini',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: widget.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 22,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['userName'] ?? 'User Tidak Diketahui',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.threadInfo['threadName'] ?? 'p/thread',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: themeColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${post['time'] ?? 'Baru saja'}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post['caption'] ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: subTextColor,
                  ),
                ),
                if (post['hasImage'] == true) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => bukaFullscreenGambar(post['imageUrl'] ?? ''),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: post['imageUrl'] ?? '',
                        child: Image.network(
                          post['imageUrl'] ?? '',
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 190,
                              color: widget.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Divider(color: borderColor, height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 18,
                          color: primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Up (${post['upvotes'] ?? 0})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 17,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['replies'] ?? 0} Reply',
                          style: TextStyle(
                            fontSize: 12,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.repeat_rounded,
                          size: 18,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Repost',
                          style: TextStyle(
                            fontSize: 12,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: subTextColor,
                    ),
                    if (post['hasImage'] == true)
                      Icon(
                        Icons.download_rounded,
                        size: 19,
                        color: primaryBlue,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}