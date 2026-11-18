// lib/controllers/thread_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/data_dummy.dart';
import 'auth_controller.dart';

class ThreadController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  var allPosts = [].obs;
  var activePostIndex = 0.obs;
  var commentList = [].obs;
  
  var replyingToUser = RxnString();
  var replyingToCommentId = RxnInt();

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  void inisialisasiDataThread(Map threadInfo) {
    if (threadInfo['posts'] == null) {
      if (threadInfo['post'] != null) {
        threadInfo['posts'] = [threadInfo['post']];
      } else {
        threadInfo['posts'] = [];
      }
    }
    allPosts.value = List.from(threadInfo['posts']);
    
    if (allPosts.isNotEmpty) {
      if (activePostIndex.value >= allPosts.length) {
        activePostIndex.value = 0;
      }
      var activeData = allPosts[activePostIndex.value];
      if (activeData['comments'] == null) {
        activeData['comments'] = [];
      }
      commentList.value = List.from(activeData['comments']);
      sortCommentsByLikes();
    } else {
      commentList.clear();
    }
  }

  void pilihPostUntukKomentar(int index) {
    if (allPosts.isEmpty) return;
    activePostIndex.value = index;
    var activeData = allPosts[activePostIndex.value];
    if (activeData['comments'] == null) {
      activeData['comments'] = [];
    }
    commentList.value = List.from(activeData['comments']);
    replyingToUser.value = null;
    replyingToCommentId.value = null;
    sortCommentsByLikes();
  }

  void sortCommentsByLikes() {
    var sortedList = List.from(commentList);
    sortedList.sort((a, b) {
      int likesA = a['likes'] ?? 0;
      int likesB = b['likes'] ?? 0;
      return likesB.compareTo(likesA);
    });
    commentList.value = sortedList;
  }

  void toggleUpvote(Map itemPost) {
    if (!authC.isLoggedIn.value) {
      // Logic pop up login bisa dipanggil lewat UI
      return;
    }
    bool isUp = itemPost['isUpvoted'] ?? false;
    int upvotes = itemPost['upvotes'] ?? 0;
    
    itemPost['isUpvoted'] = !isUp;
    itemPost['upvotes'] = isUp ? upvotes - 1 : upvotes + 1;
    
    // Perbarui state global
    allPosts.refresh();
  }

  void toggleRepost(Map itemPost) {
    if (!authC.isLoggedIn.value) return;
    itemPost['isReposted'] = !(itemPost['isReposted'] ?? false);
    allPosts.refresh();
  }

  void kirimKomentar() {
    if (!authC.isLoggedIn.value) return;
    
    String text = commentController.text.trim();
    if (text.isEmpty || allPosts.isEmpty) return;

    var activeData = allPosts[activePostIndex.value];

    if (replyingToUser.value != null && replyingToCommentId.value != null) {
      // Membalas komentar
      for (var c in commentList) {
        if (c['id'] == replyingToCommentId.value) {
          c['replies'] = c['replies'] ?? [];
          c['replies'].add({
            'userName': authC.loggedInUser.value,
            'text': text,
            'time': 'Baru saja',
            'likes': 0,
            'isLiked': false,
          });
          break;
        }
      }
    } else {
      // Komentar baru
      commentList.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'userName': authC.loggedInUser.value,
        'time': 'Baru saja',
        'text': text,
        'likes': 0,
        'isLiked': false,
        'replies': [],
      });
    }
    
    activeData['replies'] = commentList.length;
    activeData['comments'] = commentList;
    
    sortCommentsByLikes();
    allPosts.refresh(); // Memicu update UI
    
    commentController.clear();
    replyingToUser.value = null;
    replyingToCommentId.value = null;
  }

  void setReplyTo(String user, int id) {
    if (!authC.isLoggedIn.value) return;
    replyingToUser.value = user;
    replyingToCommentId.value = id;
    commentFocusNode.requestFocus();
  }

  void toggleLikeComment(Map comment) {
    if (!authC.isLoggedIn.value) return;
    bool isLiked = comment['isLiked'] ?? false;
    int likes = comment['likes'] ?? 0;
    
    comment['isLiked'] = !isLiked;
    comment['likes'] = isLiked ? likes - 1 : likes + 1;
    
    sortCommentsByLikes();
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }
}