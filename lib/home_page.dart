import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'board_page.dart';
import 'thread_page.dart';
import 'dm_page.dart';
import 'user_profile_page.dart';
import 'data_dummy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  int selectedFeedTab = 0;
  int selectedBottomNav = 0;

  bool isLoggedIn = false;
  String loggedInUser = '';
  List userTopics = [];

  final List feedTabs = ['For You', 'Following', 'Trending'];
  List riwayatDm = [];

  void bukaHistoryMessage_103022400061() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DmPage(
          isDarkMode: isDarkMode,
          riwayatDm: riwayatDm,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void bukaProfilUser_103022400061(String userName) {
    if (userName == 'ujangasep') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(
            targetUser: 'ujangasep',
            isDarkMode: isDarkMode,
            riwayatDm: riwayatDm,
          ),
        ),
      ).then((_) => setState(() {}));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil @$userName belum tersedia.'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void bukaHalamanBoard(String kategoriBoard) {
    List threadsTerpilih = [];
    for (var thread in masterThreads) {
      if (thread['boardType'] == kategoriBoard) {
        threadsTerpilih.add(thread);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(
          boardType: kategoriBoard,
          isDarkMode: isDarkMode,
          boardThreads: threadsTerpilih,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void bukaHalamanThread(Map threadItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadPage(
          threadInfo: threadItem,
          isDarkMode: isDarkMode,
          onFollowChanged: (updatedThread, status) {
            setState(() {
              for (var t in masterThreads) {
                if (t['threadName'] == updatedThread['threadName']) {
                  t['isFollowed'] = status;
                }
              }
            });
          },
        ),
      ),
    ).then((_) {
      setState(() {});
    });
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

  void terapkanTopikKeFeed(List topics) {
    if (topics.isEmpty) return;
    if (topics.contains('Mengetahui info update seputar dunia artist')) {
      for (var t in masterThreads) {
        if (t['threadName'] == 'p/ibispaint') t['isFollowed'] = true;
      }
    }
  }

  void tampilkanPopupLogin() {
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color primaryBlue = const Color(0xFF2563EB);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: primaryBlue.withValues(alpha: 0.12),
                child: Icon(Icons.lock_person_rounded, color: primaryBlue, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'Login ke Pusepuh',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
              ),
            ],
          ),
          content: Text(
            'Silakan login terlebih dahulu agar kami bisa memuat halaman profil dan menampilkan koleksi thread kamu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final hasilAuth = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(isDarkMode: isDarkMode),
                    ),
                  );

                  if (hasilAuth != null) {
                    setState(() {
                      isLoggedIn = true;
                      loggedInUser = (hasilAuth['username'] ?? 'seniman_pusepuh').toString();
                      userTopics = List.from(hasilAuth['topics'] ?? []);
                      terapkanTopikKeFeed(userTopics);
                      selectedBottomNav = 2;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List displayedThreads = [];
    if (selectedFeedTab == 0) {
      displayedThreads = List.from(masterThreads);
    } else if (selectedFeedTab == 1) {
      displayedThreads = masterThreads.where((t) => t['isFollowed'] == true).toList();
    } else {
      displayedThreads = List.from(masterThreads)..sort((a, b) {
        int upA = a['post']['upvotes'] ?? 0;
        int upB = b['post']['upvotes'] ?? 0;
        return upB.compareTo(upA);
      });
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        leading: IconButton(
          onPressed: bukaHistoryMessage_103022400061,
          icon: Icon(Icons.mail_outline_rounded, color: primaryBlue),
        ),
        centerTitle: true,
        title: Text(
          'pusepuh',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5, color: primaryBlue),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: isDarkMode ? Colors.white : Colors.black87),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined, color: isDarkMode ? Colors.amber : Colors.black87),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: selectedBottomNav == 2 && isLoggedIn
          ? ProfilePage(
              userName: loggedInUser,
              isDarkMode: isDarkMode,
              selectedTopics: List.from(userTopics),
              onLogout: () {
                setState(() {
                  isLoggedIn = false;
                  loggedInUser = '';
                  userTopics = [];
                  selectedBottomNav = 0;
                });
                tampilkanPopupLogin();
              },
            )
          : ListView(
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
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: subTextColor),
                      hintText: 'Cari topik atau thread (contoh: p/anatomi)...',
                      hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => bukaHalamanBoard('Gallery'),
                        icon: const Icon(Icons.image_outlined, size: 16),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => bukaHalamanBoard('Asking'),
                        icon: const Icon(Icons.help_outline, size: 16),
                        label: const Text('Asking'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => bukaHalamanBoard('Info'),
                        icon: const Icon(Icons.campaign_outlined, size: 16),
                        label: const Text('Info'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                
                Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderColor, width: 1.5))),
                  child: Row(
                    children: List.generate(feedTabs.length, (index) {
                      bool isSelected = selectedFeedTab == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFeedTab = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? primaryBlue : Colors.transparent, width: 3))),
                            child: Text(
                              feedTabs[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 14, color: isSelected ? primaryBlue : subTextColor),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 14),

                if (displayedThreads.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        selectedFeedTab == 1 ? 'Belum ada thread yang kamu follow.\nYuk follow thread di board pilihanmu!' : 'Tidak ada postingan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ),
                  )
                else
                  ...displayedThreads.map((threadItem) {
                    var post = threadItem['post'];
                    String bType = threadItem['boardType'] ?? 'Gallery';
                    Color bColor = getBoardColor(bType);
                    bool isFollowed = threadItem['isFollowed'] ?? false;
                    bool isReposted = post['isReposted'] ?? false;
                    String creatorUser = post['userName'] ?? 'User';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          if (!isDarkMode)
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => bukaProfilUser_103022400061(creatorUser),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                  child: Icon(Icons.person_outline_rounded, size: 22, color: subTextColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () => bukaProfilUser_103022400061(creatorUser),
                                      child: Text(
                                        creatorUser,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(width: 8, height: 8, decoration: BoxDecoration(color: bColor, shape: BoxShape.circle)),
                                        const SizedBox(width: 4),
                                        InkWell(
                                          onTap: () => bukaHalamanThread(threadItem),
                                          child: Text(threadItem['threadName'] ?? 'p/thread', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: bColor)),
                                        ),
                                        const SizedBox(width: 6),
                                        Text('• ${post['time'] ?? 'Baru saja'}', style: TextStyle(fontSize: 10, color: subTextColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    threadItem['isFollowed'] = !isFollowed;
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
                          Text(post['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                          const SizedBox(height: 6),
                          Text(post['caption'] ?? '', style: TextStyle(fontSize: 13, height: 1.4, color: subTextColor)),
                          
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
                                      return Container(width: double.infinity, height: 190, color: isDarkMode ? Colors.grey[800] : Colors.grey[300]);
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
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    bool isUp = post['isUpvoted'] ?? false;
                                    int upvotes = post['upvotes'] ?? 0;
                                    post['isUpvoted'] = !isUp;
                                    post['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_upward_rounded, size: 18, color: (post['isUpvoted'] ?? false) ? primaryBlue : subTextColor),
                                    const SizedBox(width: 4),
                                    Text('Up (${post['upvotes'] ?? 0})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: (post['isUpvoted'] ?? false) ? primaryBlue : subTextColor)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 17, color: subTextColor),
                                  const SizedBox(width: 4),
                                  Text('${post['replies'] ?? 0} Reply', style: TextStyle(fontSize: 12, color: subTextColor)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    post['isReposted'] = !isReposted;
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
                    );
                  }),
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
                onPressed: () {
                  setState(() {
                    selectedBottomNav = 0;
                  });
                },
                icon: Icon(Icons.home_filled, size: 28, color: selectedBottomNav == 0 ? (isDarkMode ? Colors.white : Colors.black) : subTextColor),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBottomNav = 1;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 26, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!isLoggedIn) {
                    tampilkanPopupLogin();
                  } else {
                    setState(() {
                      selectedBottomNav = 2;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: selectedBottomNav == 2 ? primaryBlue : subTextColor,
                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}