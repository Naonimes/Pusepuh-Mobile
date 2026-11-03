import 'package:flutter/material.dart';
import 'data_dummy.dart';
import 'following_page.dart';
import 'edit_profile_page.dart';

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
  final List<String> profileTabs = ['Repost', 'Thread Kamu'];
  
  late String currentUserName;
  String userBio = '';
  String userLink = '';

  @override
  void initState() {
    super.initState();
    currentUserName = widget.userName;
  }

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') return Colors.redAccent;
    if (boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
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

    List followedThreads = masterThreads.where((t) => t['isFollowed'] == true).toList();
    int followingCount = followedThreads.length;
    List repostedThreads = masterThreads.where((t) => t['post']['isReposted'] == true).toList();

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
                backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Icon(Icons.person_outline_rounded, size: 42, color: primaryBlue),
              ),
              const SizedBox(height: 12),
              
              // Username
              Text(
                currentUserName.isEmpty ? 'User Pusepuh' : currentUserName,
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
              ),
              
              // Bio (Muncul jika sudah diisi)
              if (userBio.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  userBio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
              ],

              // Link (Muncul jika sudah diisi)
              if (userLink.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  userLink,
                  style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.w500),
                ),
              ],

              const SizedBox(height: 12),
              
              // Bagian Statistik Following
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowingPage(
                        isDarkMode: widget.isDarkMode,
                        followedThreads: followedThreads,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      followingCount.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
                    ),
                    Text(
                      'Following Thread',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tombol Edit Profile
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        currentUserName: currentUserName,
                        isDarkMode: widget.isDarkMode,
                        onProfileSaved: (newName, newBio, newLink) {
                          setState(() {
                            currentUserName = newName;
                            userBio = newBio;
                            userLink = newLink;
                          });
                        },
                        onLogout: widget.onLogout,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryBlue,
                  side: BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderColor, width: 1.5))),
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
                      border: Border(bottom: BorderSide(color: isSelected ? primaryBlue : Colors.transparent, width: 3)),
                    ),
                    child: Text(
                      profileTabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
        
        // Tampilan Tab
        if (selectedProfileTab == 0) ...[
          if (repostedThreads.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text('Belum ada postingan yang kamu repost.', style: TextStyle(color: subTextColor, fontSize: 13)),
              ),
            )
          else
            ...repostedThreads.map((threadItem) {
              var post = threadItem['post'] ?? {};

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                          radius: 14,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person, size: 16, color: subTextColor),
                        ),
                        const SizedBox(width: 8),
                        Text(post['userName'] ?? 'User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor)),
                        const SizedBox(width: 8),
                        Icon(Icons.repeat_rounded, size: 14, color: Colors.green),
                        const SizedBox(width: 4),
                        Text('Direpost', style: TextStyle(fontSize: 10, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(post['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                    const SizedBox(height: 4),
                    Text(post['caption'] ?? '', style: TextStyle(fontSize: 12, color: subTextColor)),
                    
                    if (post['hasImage'] == true) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => bukaFullscreenGambar(post['imageUrl'] ?? ''),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: 'profile_${post['imageUrl']}',
                            child: Image.network(
                              post['imageUrl'] ?? '',
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(width: double.infinity, height: 190, color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            })
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text('Belum ada thread yang kamu buat.', style: TextStyle(color: subTextColor, fontSize: 13)),
            ),
          )
        ],
      ],
    );
  }
}