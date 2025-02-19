import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ttd/ui/home/currentDuty/appointedDuty/AppointedDutyPageViewModel.dart';
import 'package:ttd/ui/home/currentDuty/ditySituation/DutySituationPage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

class AppointedDutyPage extends StatelessWidget {
  final AppointedDutyPageViewModel viewModel = Get.put(
      AppointedDutyPageViewModel());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          bool exit = await _onWillPop(context);
          return exit;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color(0xFF172a31),
            centerTitle: true,
            title: Image.asset(
              'assets/1.png',
              width: 100,
              height: 100,
            ),
          ),
          body: Obx(() {
            if (viewModel.isLoading.value) {
              // Yükleniyor durumunda CircularProgressIndicator gösteriliyor
              return Center(child: CircularProgressIndicator());
            }

            if (viewModel.dutyList.isEmpty) {
              // Veri yoksa "Tamamlanmış Görev Yok" yazısını göster
              return Center(child: Text('Atanacak Görev Yok'));
            }

            // Veri geldiyse görev listesini göster
            return ListView.builder(
              itemCount: viewModel.dutyList.length,
              itemBuilder: (context, index) {
                var duty = viewModel.dutyList[index];
                String? roomId = duty?.roomId;

                // Eğer roomId null ise
                if (roomId == null) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Geçersiz Görev',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Oda bilgisi eksik',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // Oda adı yüklenirken CircularProgressIndicator göster
                return Obx(() {
                  if (viewModel.roomNames.value.isEmpty) {
                    viewModel.getRoomName(roomId); // RoomName'i getir
                    return Center(child: CircularProgressIndicator());
                  }

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Görev Adı : ${duty!.task![0].taskName}' ??
                            'Bilinmeyen Görev',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Oda: ${viewModel.roomNames.value}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                duty.task![0].taskName ?? 'Bilinmeyen Görev',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Görev Adı: ${duty.task![0].taskName}'),
                                  Text('Görev Açıklaması: ${duty.task![0]
                                      .taskDescription}'),
                                  Text('Oda: ${viewModel.roomNames.value}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Kapat', style: TextStyle(
                                      color: Color(0xFF172a31))),
                                ),
                                TextButton(
                                  child: Text('Görev Talebi Oluştur',
                                      style: TextStyle(
                                          color: Color(0xFF172a31))),
                                  onPressed: () async {
                                    if (duty != null && duty.roomId != null && duty.task != null) {
                                      await viewModel.addDutyAssignment(duty.roomId!, duty.task![0].taskName ?? '');
                                      Navigator.of(context).pop(); // Dialog'u kapat
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Görev verileri eksik, işlem gerçekleştirilemedi.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                });
              },
            );
          }),
        ),
      ),
    );
  }
  Future<bool> _onWillPop(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
    return exit;
  }
}