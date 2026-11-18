// lib/controllers/creation_controllers.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/data_dummy.dart';
import 'auth_controller.dart';

// --- CONTROLLER UNTUK CREATE POST ---
class CreatePostController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  var selectedThreadName = ''.obs;
  var selectedMediaType = 'Gambar'.obs;
  final List mediaTypes = ['Teks', 'Gambar', 'Video', 'Lokasi'];

  var currentLink = ''.obs;

  void inisialisasi(String? initialThreadName) {
    if (initialThreadName != null && initialThreadName.isNotEmpty) {
      selectedThreadName.value = initialThreadName;
    } else if (masterThreads.isNotEmpty) {
      selectedThreadName.value = (masterThreads[0]['threadName'] ?? 'p/umamusume').toString();
    } else {
      selectedThreadName.value = 'p/umum';
    }

    // Listener untuk link preview
    linkController.addListener(() {
      currentLink.value = linkController.text.trim();
    });
  }

  void ubahThread(String tName) {
    selectedThreadName.value = tName;
  }

  void ubahMediaType(String mType) {
    selectedMediaType.value = mType;
  }

  void clearLink() {
    linkController.clear();
    currentLink.value = '';
  }

  void publikasikanPostingan(BuildContext context) {
    String title = titleController.text.trim();
    String cap = captionController.text.trim();
    String link = linkController.text.trim();

    if (title.isEmpty || cap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan caption postingan wajib diisi!')),
      );
      return;
    }

    bool pakeGambar = (selectedMediaType.value != 'Teks') && link.isNotEmpty;

    Map newPost = {
      'userName': authC.loggedInUser.value,
      'time': 'Baru saja',
      'title': title,
      'caption': cap,
      'hasImage': pakeGambar,
      'imageUrl': pakeGambar ? link : '',
      'mediaType': selectedMediaType.value,
      'upvotes': 0,
      'isUpvoted': false,
      'replies': 0,
      'isReposted': false,
      'comments': [],
    };

    Map? targetThread;
    for (var t in masterThreads) {
      if (t['threadName'] == selectedThreadName.value) {
        targetThread = t;
        break;
      }
    }

    if (targetThread != null) {
      if (targetThread['posts'] == null) {
        targetThread['posts'] = [targetThread['post']];
      }
      targetThread['posts'].insert(0, newPost);
    }

    Get.back(result: targetThread);
  }

  @override
  void onClose() {
    titleController.dispose();
    captionController.dispose();
    linkController.dispose();
    super.onClose();
  }
}

// --- CONTROLLER UNTUK CREATE THREAD ---
class CreateThreadController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  
  var selectedBoard = 'Gallery'.obs;
  final List boards = ['Gallery', 'Asking', 'Info'];

  void inisialisasi(String? initialBoard) {
    selectedBoard.value = initialBoard ?? 'Gallery';
  }

  void ubahBoard(String b) {
    selectedBoard.value = b;
  }

  void buatThreadBaru(BuildContext context) {
    String rawName = nameController.text.trim().replaceAll(' ', '_').toLowerCase();
    String cap = captionController.text.trim();

    if (rawName.isEmpty || cap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama thread dan deskripsi thread wajib diisi!')),
      );
      return;
    }

    String finalThreadName = rawName.startsWith('p/') ? rawName : 'p/$rawName';

    Map placeholderPost = {
      'userName': authC.loggedInUser.value,
      'time': 'Baru saja',
      'title': cap,
      'caption': cap,
      'hasImage': false,
      'imageUrl': '',
      'upvotes': 0,
      'isUpvoted': false,
      'replies': 0,
      'isReposted': false,
      'comments': [],
    };

    Map newThread = {
      'threadName': finalThreadName,
      'boardType': selectedBoard.value,
      'threadCreator': authC.loggedInUser.value,
      'threadDescription': cap,
      'isFollowed': true,
      'post': placeholderPost,
      'posts': [],
    };

    masterThreads.insert(0, newThread);
    Get.back(result: newThread);
  }

  @override
  void onClose() {
    nameController.dispose();
    captionController.dispose();
    super.onClose();
  }
}