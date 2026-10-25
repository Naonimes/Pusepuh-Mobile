import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  int selectedFeedTab = 0;
  int selectedBottomNav = 0;
  String selectedBoard = 'Semua';

  final List<String> feedTabs = ['For You', 'Following', 'Trending'];

  final Map<int, List<Map<String, dynamic>>> allThreads = {
    0: [
      {
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
      {
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
        'isReposted': false,
      },
    ],
    1: [
      {
        'threadName': 'p/grayscale',
        'boardType': 'Asking',
        'time': '2j yang lalu',
        'title': 'tolong T_T',
        'caption': 'cara render metode grayscale tu gimana sih? sampai sekaerang aku masih bingung, ada yang bisa kasih tips ga?',
        'hasImage': false,
        'imageUrl': '',
        'upvotes': 19,
        'replies': 8,
        'isUpvoted': false,
        'isFollowed': true,
        'isReposted': false,
      },
      {
        'threadName': 'p/background_scene',
        'boardType': 'Gallery',
        'time': '4j yang lalu',
        'title': 'background scene',
        'caption': 'aku mau minta gambar landscape dengan background yang bentuknya tuh kaya scene di film2 / anime kaya gini, boleh di share ya karya kalian :D',
        'hasImage': true,
        'imageUrl': 'https://www.shutterstock.com/shutterstock/videos/1106937695/thumb/1.jpg?ip=x480',
        'upvotes': 64,
        'replies': 11,
        'isUpvoted': false,
        'isFollowed': true,
        'isReposted': false,
      },
    ],
    2: [
      {
        'threadName': 'p/event_komunitas',
        'boardType': 'Info',
        'time': '2m yang lalu',
        'title': 'main yuk',
        'caption': 'info nih ada event komik di bandung hari sabtu tanggal 32 desember 2026, ini tautan lokasinya ya, gas mampir!',
        'hasImage': false,
        'imageUrl': '',
        'upvotes': 310,
        'replies': 89,
        'isUpvoted': true,
        'isFollowed': false,
        'isReposted': true,
      },
      {
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

  Color getBoardColor(String boardType) {
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
    Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);

    List<Map<String, dynamic>> currentThreads =
        allThreads[selectedFeedTab] ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'pusepuh',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: -0.5,
            color: primaryBlue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
              color: isDarkMode ? Colors.amber : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
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
                  onPressed: () {
                    setState(() {
                      selectedBoard = 'Gallery';
                    });
                  },
                  icon: const Icon(Icons.image_outlined, size: 16),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedBoard = 'Asking';
                    });
                  },
                  icon: const Icon(Icons.help_outline, size: 16),
                  label: const Text('Asking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedBoard = 'Info';
                    });
                  },
                  icon: const Icon(Icons.campaign_outlined, size: 16),
                  label: const Text('Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1.5),
              ),
            ),
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
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? primaryBlue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        feedTabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
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
          ...currentThreads.map((thread) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
                boxShadow: [
                  if (!isDarkMode)
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: getBoardColor(thread['boardType']),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            thread['threadName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: getBoardColor(thread['boardType']),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${thread['time']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: subTextColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            thread['isFollowed'] = !thread['isFollowed'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: thread['isFollowed']
                                ? Colors.transparent
                                : primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: thread['isFollowed']
                                  ? subTextColor
                                  : primaryBlue,
                            ),
                          ),
                          child: Text(
                            thread['isFollowed'] ? 'Following' : '+ Follow',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: thread['isFollowed']
                                  ? subTextColor
                                  : primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    thread['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    thread['caption'],
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
                        thread['imageUrl'],
                        width: double.infinity,
                        height: 190,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 190,
                            color: isDarkMode
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
                            thread['isUpvoted'] = !thread['isUpvoted'];
                            if (thread['isUpvoted']) {
                              thread['upvotes'] += 1;
                            } else {
                              thread['upvotes'] -= 1;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 18,
                              color: thread['isUpvoted']
                                  ? primaryBlue
                                  : subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Up (${thread['upvotes']})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: thread['isUpvoted']
                                    ? primaryBlue
                                    : subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 17,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${thread['replies']} Reply',
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            thread['isReposted'] = !thread['isReposted'];
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                thread['isReposted']
                                    ? 'Thread berhasil di-repost ke profilmu!'
                                    : 'Repost dibatalkan.',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.repeat_rounded,
                              size: 18,
                              color: thread['isReposted']
                                  ? Colors.green
                                  : subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Repost',
                              style: TextStyle(
                                fontSize: 12,
                                color: thread['isReposted']
                                    ? Colors.green
                                    : subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: subTextColor,
                        ),
                      ),
                      if (thread['hasImage'] == true)
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Mengunduh media ke penyimpanan lokal...',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.download_rounded,
                            size: 19,
                            color: primaryBlue,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Container(
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
              icon: Icon(
                Icons.home_filled,
                size: 28,
                color: selectedBottomNav == 0
                    ? (isDarkMode ? Colors.white : Colors.black)
                    : subTextColor,
              ),
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
                decoration: BoxDecoration(
                  color: primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedBottomNav = 2;
                });
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: primaryBlue,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}