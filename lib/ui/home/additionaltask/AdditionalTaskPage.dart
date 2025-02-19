import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/rest/responses/additionaltask/Task.dart';
import 'AdditionalTaskPageViewModel.dart';

class AdditionalTaskPage extends StatelessWidget {
  final AdditionalTaskPageViewModel viewModel = Get.put(AdditionalTaskPageViewModel());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xFF172a31),
          centerTitle: true,  // Title'ı ortalamak için yeterli
          title: Image.asset(
            'assets/1.png',
            width: 100,
            height: 100,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => viewModel.updateListView(), // Yukarı kaydırıldığında güncelleme yapılacak
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Yukarı kaydırmayı aktif etmek için
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: Obx(() {
                    if (viewModel.taskList.isEmpty) {
                      return Center(child: Text('Herhangi Bir Ek Görev Bulunmuyor'));
                    } else {
                      return ListView.builder(
                        itemCount: viewModel.taskList.length,
                        itemBuilder: (context, index) {
                          String taskName = viewModel.taskList[index].taskName ?? "Unknown";
                          return Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF172a31),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: ListTile(
                              title: Text(
                                taskName,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      );
                    }
                  }),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
