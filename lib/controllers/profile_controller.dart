// lib/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/data_dummy.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  var selectedProfileTab = 0.obs;
  final List<String> profileTabs = ['Repost', 'Thread Kamu'];
  
  var currentUserName = ''.obs;
  var userBio = ''.obs;
  var userLink = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUserName.value = authC.loggedInUser.value;
  }

  void ubahProfileTab(int index) {
    selectedProfileTab.value = index;
  }

  void saveProfile(String newName, String newBio, String newLink) {
    currentUserName.value = newName.isEmpty ? 'Seniman Tanpa Nama' : newName;
    userBio.value = newBio;
    userLink.value = newLink;
    
    // Perbarui username di AuthController juga agar sinkron
    authC.loggedInUser.value = currentUserName.value;
  }

  void logout() {
    authC.isLoggedIn.value = false;
    authC.loggedInUser.value = '';
    authC.userTopics.clear();
    Get.back(); // Kembali ke halaman utama setelah logout
  }

  // Getter reaktif untuk mengikuti thread
  List get followedThreads {
    return masterThreads.where((t) => t['isFollowed'] == true).toList();
  }

  // Getter reaktif untuk item repost
  List get repostedItems {
    List items = [];
    for (var t in masterThreads) {
      List threadPosts = t['posts'] ?? [t['post']];
      for (var p in threadPosts) {
        if (p != null && p['isReposted'] == true) {
          items.add({'thread': t, 'post': p});
        }
      }
    }
    return items;
  }

  // Getter reaktif untuk karya sendiri
  List get myCreatedItems {
    List items = [];
    for (var t in masterThreads) {
      List threadPosts = t['posts'] ?? [t['post']];
      for (var p in threadPosts) {
        if (p != null && (p['userName'] == currentUserName.value)) {
          items.add({'thread': t, 'post': p});
        }
      }
    }
    return items;
  }
}