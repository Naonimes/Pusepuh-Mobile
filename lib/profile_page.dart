import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final bool isDarkMode;
  final List<String> selectedTopics;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.isDarkMode,
    required this.selectedTopics,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedProfileTab = 0;
  final List<String> profileTabs = ['Repost', 'Thread Kamu', 'Disimpan'];

  late Map<int, List<Map<String, dynamic>>> profileThreads;

  @override
  void initState() {
    super.initState();
    profileThreads = {
      0: [
        {
          'userName': 'suamisahopera',
          'threadName': 'p/umamusume',
          'boardType': 'Gallery',
          'time': '3j yang lalu',
          'title': 'tm opera o!',
          'caption': 'kalian yang pernah gambar karakter opera o boleh di share dong :D',
          'hasImage': true,
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqT8zUkQh934e4HNZJ9uruqYApm2aFWNuKiCl_XNWT3pBpHp5aMGoIJnFR&s=10',
          'upvotes': 128,
          'replies': 34,
          'isUpvoted': true,
          'isFollowed': true,
          'isReposted': true,
        },
      ],
      1: [
        {
          'userName': widget.userName,
          'threadName': 'p/kritik_saran',
          'boardType': 'Asking',
          'time': '2j yang lalu',
          'title': 'infokan dong',
          'caption': 'guys kira-kira ada yang kurang ga dari gambarku ini?',
          'hasImage': true,
          'imageUrl': 'https://preview.redd.it/my-t-m-opera-o-fanart-v0-gupydts7e93h1.jpeg?auto=webp&s=23d1b2f73eff39480c6a4467144561d8b62969b8',
          'upvotes': 42,
          'replies': 15,
          'isUpvoted': false,
          'isFollowed': false,
          'isReposted': false,
        },
      ],
      2: [
        {
          'userName': 'Salaluak',
          'threadName': 'p/komik_indie',
          'boardType': 'Info',
          'time': '5m yang lalu',
          'title': 'komik indie',
          'caption': 'sekarang aplikasi ibis paint bisa sediain 3d model pose loh! tapi cuman khusus premium doang wkwk',
          'hasImage': true,
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGC6hUUEzDxAcxPWh-NLPaHvr6H83M39X9qU8rxbQGbbQLz0zHNrt3lmY&s=10',
          'upvotes': 215,
          'replies': 52,
          'isUpvoted': false,
          'isFollowed': true,
          'isReposted': false,
        },
      ],
    };
  }

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') {
      return Colors.redAccent;
    } else if (boardType == 'Info') {
      return Colors.amber[700]!;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List<Map<String, dynamic>> currentList =
        profileThreads[selectedProfileTab] ?? [];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor:
                    widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 42,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.userName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Seniman Visual Pusepuh',
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                ),
              ),
              if (widget.selectedTopics.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: widget.selectedTopics.map((topik) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        topik,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: primaryBlue,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text('Keluar Akun'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: borderColor, width: 1.5),
            ),
          ),
          child: Row(
            children: List.generate(profileTabs.length, (index) {
              bool isSelected = selectedProfileTab == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedProfileTab = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? primaryBlue : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      profileTabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                        color: isSelected ? primaryBlue : subTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        ...currentList.map((thread) {
          String displayUser = selectedProfileTab == 1
              ? widget.userName
              : (thread['userName'] ?? 'User');
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: [
                if (!widget.isDarkMode)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
              ],
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
                            displayUser,
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
                                  color: getBoardColor(
                                      thread['boardType']?.toString()),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                thread['threadName'] ?? 'p/thread',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: getBoardColor(
                                      thread['boardType']?.toString()),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${thread['time'] ?? 'Baru saja'}',
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
                  thread['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  thread['caption'] ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: subTextColor,
                  ),
                ),
                if (thread['hasImage'] == true) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      thread['imageUrl'] ?? '',
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
                ],
                const SizedBox(height: 12),
                Divider(color: borderColor, height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          bool isUp = thread['isUpvoted'] ?? false;
                          int upvotes = thread['upvotes'] ?? 0;
                          thread['isUpvoted'] = !isUp;
                          if (!isUp) {
                            thread['upvotes'] = upvotes + 1;
                          } else {
                            thread['upvotes'] = upvotes - 1;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: (thread['isUpvoted'] ?? false)
                                ? primaryBlue
                                : subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Up (${thread['upvotes'] ?? 0})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: (thread['isUpvoted'] ?? false)
                                  ? primaryBlue
                                  : subTextColor,
                            ),
                          ),
                        ],
                      ),
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
                          '${thread['replies'] ?? 0} Reply',
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
                          color: (thread['isReposted'] ?? false)
                              ? Colors.green
                              : subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Repost',
                          style: TextStyle(
                            fontSize: 12,
                            color: (thread['isReposted'] ?? false)
                                ? Colors.green
                                : subTextColor,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: subTextColor,
                    ),
                    if (thread['hasImage'] == true)
                      Icon(
                        Icons.download_rounded,
                        size: 19,
                        color: primaryBlue,
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}