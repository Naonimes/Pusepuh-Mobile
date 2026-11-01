import 'package:flutter/material.dart';
import 'thread_page.dart';

class BoardPage extends StatefulWidget {
  final String boardType;
  final bool isDarkMode;
  final List boardThreads;

  const BoardPage({
    super.key,
    required this.boardType,
    required this.isDarkMode,
    required this.boardThreads,
  });

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  String searchQuery = '';
  bool isCompactMode = false;

  Color getBoardColor(String? boardType) {
    if (boardType == 'Asking') {
      return Colors.redAccent;
    } else if (boardType == 'Info') {
      return Colors.amber[700]!;
    } else {
      return Colors.green;
    }
  }

  IconData getBoardIcon(String boardType) {
    if (boardType == 'Asking') {
      return Icons.help_outline_rounded;
    } else if (boardType == 'Info') {
      return Icons.campaign_outlined;
    } else {
      return Icons.image_outlined;
    }
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
    Color themeBoardColor = getBoardColor(widget.boardType);

    List filteredThreads = [];
    for (var item in widget.boardThreads) {
      String q = searchQuery.toLowerCase();
      String tName = (item['threadName'] ?? '').toString().toLowerCase();
      String desc = (item['threadDesc'] ?? '').toString().toLowerCase();
      String creator = (item['threadCreator'] ?? '').toString().toLowerCase();

      if (tName.contains(q) || desc.contains(q) || creator.contains(q)) {
        filteredThreads.add(item);
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getBoardIcon(widget.boardType),
              color: themeBoardColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Board ${widget.boardType}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: themeBoardColor,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: subTextColor),
                      hintText: 'Cari thread di board ${widget.boardType}...',
                      hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCompactMode = false;
                        });
                      },
                      icon: Icon(
                        Icons.view_agenda_outlined,
                        size: 20,
                        color: !isCompactMode ? themeBoardColor : subTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCompactMode = true;
                        });
                      },
                      icon: Icon(
                        Icons.grid_view_rounded,
                        size: 20,
                        color: isCompactMode ? themeBoardColor : subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (filteredThreads.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Tidak ada thread yang ditemukan.',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              ),
            )
          else if (!isCompactMode)
            ...filteredThreads.map((threadData) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: themeBoardColor.withValues(alpha: 0.4),
                      width: 1.2),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: themeBoardColor.withValues(alpha: 0.12),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                getBoardIcon(widget.boardType),
                                size: 18,
                                color: themeBoardColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                threadData['threadName'] ?? 'p/thread',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: themeBoardColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Oleh @${threadData['threadCreator'] ?? 'admin'}',
                            style: TextStyle(
                              fontSize: 11,
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            threadData['threadDesc'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subTextColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dibuat: ${threadData['threadDate'] ?? 'Baru saja'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: subTextColor,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ThreadPage(
                                        threadInfo: threadData,
                                        isDarkMode: widget.isDarkMode,
                                        onFollowChanged:
                                            (updatedThread, status) {
                                          setState(() {
                                            threadData['isFollowed'] = status;
                                          });
                                        },
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_rounded,
                                    size: 14),
                                label: const Text('Lihat Thread'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: filteredThreads.length,
              itemBuilder: (context, index) {
                var threadData = filteredThreads[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadPage(
                          threadInfo: threadData,
                          isDarkMode: widget.isDarkMode,
                          onFollowChanged: (updatedThread, status) {
                            setState(() {
                              threadData['isFollowed'] = status;
                            });
                          },
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeBoardColor.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          getBoardIcon(widget.boardType),
                          size: 20,
                          color: themeBoardColor,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          threadData['threadName'] ?? 'p/thread',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: themeBoardColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Oleh @${threadData['threadCreator'] ?? 'admin'}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}