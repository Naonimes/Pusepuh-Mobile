import 'package:flutter/material.dart';
import 'thread_page.dart';
import 'create_thread_page.dart';

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
    return 'Ruang komunitas di board $bType untuk berdiskusi dan berbagi karya seputar topik$tName.';
  }

  void bukaFormTambahThread() async {
    if (!widget.isLoggedIn) {
      if (widget.onLoginRequired != null) {
        widget.onLoginRequired!();
      }
      return;
    }

    final hasilThreadBaru = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateThreadPage(
          isDarkMode: widget.isDarkMode,
          loggedInUser: widget.loggedInUser,
          initialBoard: widget.boardType,
        ),
      ),
    );

    if (hasilThreadBaru != null && hasilThreadBaru is Map) {
      setState(() {
        if (hasilThreadBaru['boardType'] == widget.boardType) {
          widget.boardThreads.insert(0, hasilThreadBaru);
        }
      });
      bukaHalamanThread(hasilThreadBaru);
    }
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
        String desc = ambilDeskripsiThread(t).toLowerCase();
        String query = searchQuery.toLowerCase();
        return tName.contains(query) || desc.contains(query);
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: bukaFormTambahThread,
              icon: Icon(Icons.add_circle_outline_rounded, size: 18, color: bColor),
              label: Text(
                'Thread',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13, color: bColor),
              ),
            ),
          ),
        ],
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
                hintText: 'Cari thread di board ${widget.boardType}...',
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
                      subtitle: Text(ambilDeskripsiThread(t), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: subTextColor, fontSize: 11)),
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
                  'Belum ada thread di Board ini.',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              ),
            )
          else if (searchQuery.isEmpty)
            ...widget.boardThreads.map((threadItem) {
              bool isFollowed = threadItem['isFollowed'] ?? false;
              String threadName = threadItem['threadName'] ?? 'p/thread';
              String creator = ambilPembuatThread(threadItem);
              String threadDesc = ambilDeskripsiThread(threadItem);

              return InkWell(
                onTap: () => bukaHalamanThread(threadItem),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      if (!widget.isDarkMode)
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: bColor.withValues(alpha: 0.15),
                            child: Icon(Icons.tag, color: bColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  threadName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Dibuat oleh @$creator',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: bColor),
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      const SizedBox(height: 10),
                      Divider(color: borderColor, height: 1),
                      const SizedBox(height: 8),
                      Text(
                        threadDesc,
                        style: TextStyle(fontSize: 12.5, color: subTextColor, height: 1.4),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}