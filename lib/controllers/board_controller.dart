// lib/controllers/board_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BoardController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
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
}