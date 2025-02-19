
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'EmployeeDutyLocationsPageViewModel.dart';

class EmployeeDutyLocationsPage extends StatelessWidget {
  final EmployeeDutyLocationsPageViewModel viewModel = Get.put(EmployeeDutyLocationsPageViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bulunduğum Koridorlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.corridors.length,
                      itemBuilder: (context, index) {
                        var corridor = viewModel.corridors[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              corridor,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bulunduğum Şubeler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.branches.length,
                      itemBuilder: (context, index) {
                        var branch = viewModel.branches[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              branch,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}