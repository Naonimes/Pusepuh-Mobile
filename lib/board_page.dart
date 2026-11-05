import 'package:flutter/material.dart';
import 'thread_page.dart';

class BoardPage extends StatefulWidget {
  final String boardType;
  final bool isDarkMode;
  final List boardThreads;
  
  final bool isLoggedIn;
  final String loggedInUser;
  final VoidCallback? onLoginRequired;
  final Function(Map, bool)? onFollowChanged;

  const BoardPage({
    super.key,
    required this.boardType,
    required this.isDarkMode,
    required this.boardThreads,
    this.isLoggedIn = false,
    this.loggedInUser = '',
    this.onLoginRequired,
    this.onFollowChanged,
  });

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Color getBoardColor() {
    if (widget.boardType == 'Asking') return Colors.redAccent;
    if (widget.boardType == 'Info') return Colors.amber[700]!;
    return Colors.green;
  }

  void bukaHalamanThread(Map threadItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadPage(
          threadInfo: threadItem,
          isDarkMode: widget.isDarkMode,
          isLoggedIn: widget.isLoggedIn,
          loggedInUser: widget.loggedInUser,
          onLoginRequired: widget.onLoginRequired,
          onFollowChanged: (updatedThread, status) {
            setState(() {
              if (widget.onFollowChanged != null) {
                widget.onFollowChanged!(updatedThread, status);
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

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color cardColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    Color borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    Color primaryBlue = const Color(0xFF2563EB);
    Color bColor = getBoardColor();

    List searchResults = [];
    if (searchQuery.isNotEmpty) {
      searchResults = widget.boardThreads.where((t) {
        String tName = (t['threadName'] ?? '').toString().toLowerCase();
        String pTitle = (t['post']['title'] ?? '').toString().toLowerCase();
        String query = searchQuery.toLowerCase();
        return tName.contains(query) || pTitle.contains(query);
      }).toList();
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Board: ${widget.boardType}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: bColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: subTextColor),
                hintText: 'Cari di board ${widget.boardType}...',
                hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                border: InputBorder.none,
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 18, color: subTextColor),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
              ),
            ),
          ),
          
          if (searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Hasil Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: bColor)),
                  ),
                  if (searchResults.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text('Tidak ada hasil di board ini.', style: TextStyle(color: subTextColor, fontSize: 13)),
                    )
                  else
                    ...searchResults.map((t) => ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: bColor.withValues(alpha: 0.15),
                        child: Icon(Icons.tag, size: 16, color: bColor),
                      ),
                      title: Text(t['threadName'] ?? '', style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(t['post']['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: subTextColor, fontSize: 11)),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                        bukaHalamanThread(t);
                      },
                    )),
                ],
              ),
            ),
            
          if (searchQuery.isEmpty) const SizedBox(height: 16),

          if (searchQuery.isEmpty && widget.boardThreads.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Belum ada postingan di Board ini.',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              ),
            )
          else if (searchQuery.isEmpty)
            ...widget.boardThreads.map((threadItem) {
              var post = threadItem['post'];
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
                    if (!widget.isDarkMode)
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
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
                          backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          child: Icon(Icons.person_outline_rounded, size: 22, color: subTextColor),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                creatorUser,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
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
                            if (!widget.isLoggedIn) {
                              if (widget.onLoginRequired != null) {
                                widget.onLoginRequired!();
                              }
                              return;
                            }
                            setState(() {
                              threadItem['isFollowed'] = !isFollowed;
                              if (widget.onFollowChanged != null) {
                                widget.onFollowChanged!(threadItem, !isFollowed);
                              }
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
                            tag: 'board_${post['imageUrl']}',
                            child: Image.network(
                              post['imageUrl'] ?? '',
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
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
                            if (!widget.isLoggedIn) {
                              if (widget.onLoginRequired != null) {
                                widget.onLoginRequired!();
                              }
                              return;
                            }
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
                        InkWell(
                          onTap: () => bukaHalamanThread(threadItem),
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded, size: 17, color: subTextColor),
                              const SizedBox(width: 4),
                              Text('${post['replies'] ?? 0} Reply', style: TextStyle(fontSize: 12, color: subTextColor)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!widget.isLoggedIn) {
                              if (widget.onLoginRequired != null) {
                                widget.onLoginRequired!();
                              }
                              return;
                            }
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
    );
  }
}