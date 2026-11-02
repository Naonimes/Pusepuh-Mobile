import 'package:flutter/material.dart';
import 'data_dummy.dart'; // <--- Memanggil sumber data utama kita

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
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    // Mengambil data secara dinamis dari data_dummy.dart
    List currentList = [];
    if (masterThreads.isNotEmpty) {
      if (selectedProfileTab == 0 && masterThreads.length > 2) {
        currentList = [masterThreads[2]]; // Contoh Repost: Umamusume
      } else if (selectedProfileTab == 1) {
        currentList = [masterThreads[0]]; // Contoh Thread Kamu: Kritik Saran
      } else if (selectedProfileTab == 2 && masterThreads.length > 5) {
        currentList = [masterThreads[5]]; // Contoh Disimpan: IbisPaint
      }
    }

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
        ...currentList.map((threadItem) {
          var post = threadItem['post'] ?? {};
          String bType = threadItem['boardType'] ?? 'Gallery';
          Color bColor = getBoardColor(bType);
          
          // Mengganti nama user menjadi nama kita saat di tab 'Thread Kamu'
          String displayUser = selectedProfileTab == 1
              ? widget.userName
              : (post['userName'] ?? 'User');
              
          bool isReposted = selectedProfileTab == 0; 

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
                                  color: bColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                threadItem['threadName'] ?? 'p/thread',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: bColor,
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
                          color: (post['isUpvoted'] ?? false)
                              ? primaryBlue
                              : subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Up (${post['upvotes'] ?? 0})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (post['isUpvoted'] ?? false)
                                ? primaryBlue
                                : subTextColor,
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
                          color: isReposted ? Colors.green : subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Repost',
                          style: TextStyle(
                            fontSize: 12,
                            color: isReposted ? Colors.green : subTextColor,
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
          );
        }),
      ],
    );
  }
}