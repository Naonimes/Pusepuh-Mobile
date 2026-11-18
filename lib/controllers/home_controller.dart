// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'auth_controller.dart';
import '../models/data_dummy.dart';

class HomeController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  var isDarkMode = false.obs;
  var selectedFeedTab = 0.obs;
  var selectedBottomNav = 0.obs;
  var searchQuery = ''.obs;
  
  final TextEditingController searchController = TextEditingController();
  final List feedTabs = ['For You', 'Following', 'Trending'];
  var riwayatDm = [].obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void ubahFeedTab(int index) {
    selectedFeedTab.value = index;
  }

  // REVISI 1: Jika index 2 (Profile) ditekan saat belum login, munculkan popup
  void ubahBottomNav(int index, {VoidCallback? onLoginRequired}) {
    if (index == 2 && !authC.isLoggedIn.value) {
      if (onLoginRequired != null) onLoginRequired();
      return;
    }
    selectedBottomNav.value = index;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  List get searchResults {
    if (searchQuery.value.isEmpty) return [];
    return masterThreads.where((t) {
      String tName = (t['threadName'] ?? '').toString().toLowerCase();
      String pTitle = (t['post']['title'] ?? '').toString().toLowerCase();
      String query = searchQuery.value.toLowerCase();
      return tName.contains(query) || pTitle.contains(query);
    }).toList();
  }

  // REVISI 2: Tab Following menampilkan seluruh postingan dari thread yang di-follow
  List get feedItems {
    List items = [];
    for (var t in masterThreads) {
      if (selectedFeedTab.value == 1 && t['isFollowed'] != true) {
        continue;
      }
      List threadPosts = t['posts'] ?? [t['post']];
      for (var p in threadPosts) {
        items.add({
          'thread': t,
          'post': p,
        });
      }
    }

    if (selectedFeedTab.value == 2) {
      items.sort((a, b) {
        int upA = a['post']['upvotes'] ?? 0;
        int upB = b['post']['upvotes'] ?? 0;
        return upB.compareTo(upA);
      });
    }
    return items;
  }

  void toggleFollow(Map threadItem) {
  if (!authC.isLoggedIn.value) return;
  bool currentStatus = threadItem['isFollowed'] ?? false;
  
  int index = masterThreads.indexWhere((t) => t['threadName'] == threadItem['threadName']);
  if (index != -1) {
    Map updatedThread = Map.from(masterThreads[index]);
    updatedThread['isFollowed'] = !currentStatus;

    masterThreads[index] = updatedThread; 
    
    masterThreads.assignAll(List.from(masterThreads)); 
  }
}
}