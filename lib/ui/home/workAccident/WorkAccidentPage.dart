import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkAccidentPage extends StatelessWidget {
  final int _gunduzKaza = 0; // Kaza yaşanmayan gün sayısı

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF172A31), // Arka plan rengi
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,
        title: Image.asset(
          'assets/1.png',
          width: 100,
          height: 100,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // İkon rengi
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bu iş yerinde',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0, // Ana metin boyutu
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0), // Metinler arası boşluk
            Text(
              '$_gunduzKaza', // Gün sayısı
              style: TextStyle(
                color: Colors.white,
                fontSize: 80.0, // Gün sayısı için büyük font
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'gündür kaza yaşanmadı!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}