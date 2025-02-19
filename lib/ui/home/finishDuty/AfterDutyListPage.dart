import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/models/rest/responses/duty/Duty.dart';
import 'package:ttd/models/rest/responses/duty/roomDuty/RoomDuty.dart';
import 'package:ttd/ui/home/finishDuty/AfterDutyListPageViewModel.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPageViewModel.dart';

import '../../../models/rest/responses/additionaltask/Task.dart';
import '../../../models/rest/responses/duty/dutyById/DutyByIdResponse.dart';
import '../../../models/rest/responses/duty/roomDuty/Tasks.dart';



class AfterDutyListPage extends StatelessWidget {
  final String dutyId;
  final takePhotoViewModel = Get.put(FinishTakePhotoPageViewModel()); // TakePhotoPageViewModel'i kullanıyoruz

  AfterDutyListPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    print("gelen dutyID iş bitiriş $dutyId");
    final viewModel = Get.put(AfterDutyListPageViewModel());
    return Scaffold(
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
      body: FutureBuilder<void>(
        future: takePhotoViewModel.getDutyFromRoomId(dutyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (takePhotoViewModel.roomInfo?.task == null || takePhotoViewModel.roomInfo!.task.isEmpty) {
            return Center(child: Text('Görev bulunamadı.'));
          } else {
            var activeTasks = takePhotoViewModel.roomInfo!.task.where((task) => task.status == true).toList();

            if (activeTasks.isEmpty) {
              return Center(
                child: Text(
                  'Bu Odaya Atanmış Görev Yoktur',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Yapılmış Görevler", // Görev adı gösteriliyor.
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: activeTasks.length,
                      itemBuilder: (context, index) {
                        var task = activeTasks[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Görev Adı : ${task.taskName}' ?? 'Bilinmeyen Görev',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Görev Açıklaması : ${task.taskDescription}' ?? 'Bilinmeyen Açıklama',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: Icon(
                              Icons.check_circle,
                              color: Color(0xFF2D75FD),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print("Giden duty ID ${dutyId}");
                        _showFinishTaskDialog(context, viewModel, dutyId);
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF172a31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        child: Text(
                          'Görevi Bitir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showFinishTaskDialog(BuildContext context, AfterDutyListPageViewModel viewModel, String dutyId) {
    List<TextEditingController> quantityControllers = List.generate(
      viewModel.materials.length,
          (index) => TextEditingController(text: '0'),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Oda Envanterleri',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...viewModel.materials.map((material) {
                  int index = viewModel.materials.indexOf(material);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            material.name, // Malzeme adı
                            style: TextStyle(
                              fontSize: 18, // Ürün isminin fontunu büyüttük
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                int currentValue = int.parse(quantityControllers[index].text);
                                if (currentValue > 0) {
                                  currentValue--;
                                  quantityControllers[index].text = currentValue.toString();
                                }
                              },
                              child: Icon(Icons.remove),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(5), // Buton boyutunu küçülttük
                                backgroundColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: quantityControllers[index],
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                int currentValue = int.parse(quantityControllers[index].text);
                                currentValue++;
                                quantityControllers[index].text = currentValue.toString();
                              },
                              child: Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(5), // Buton boyutunu küçülttük
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal', style: TextStyle(color: Color(0xFF172a31))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Envanter Kaydet', style: TextStyle(color: Color(0xFF172a31))),
              onPressed: () {
                // Envanter kaydetme ve ikinci dialogu açmak için işlemi başlatıyoruz
                _handleStockAndFinishDuty(context, viewModel, dutyId, quantityControllers);
              },
            ),
          ],
        );
      },
    );
  }
  void _handleStockAndFinishDuty(BuildContext context, AfterDutyListPageViewModel viewModel, String dutyId, List<TextEditingController> quantityControllers) async {
    try {
      // Seçilen malzemeleri ve miktarları işliyoruz
      for (int i = 0; i < viewModel.materials.length; i++) {
        String selectedQuantity = quantityControllers[i].text;
        String productId = viewModel.materials[i].id;  // Malzemenin ID'si alınıyor

        // Eğer miktar sıfır değilse, stok işlemi yapılacak
        if (int.parse(selectedQuantity) > 0) {
          viewModel.selectedMaterial.value = productId;
          await viewModel.finishDutyAndAddStockItem(context, dutyId, selectedQuantity);
        }
      }

      // Stok başarıyla eklendikten sonra görev bitirme onayı için yeni dialog açılıyor
      _showConfirmFinishDialog(context, viewModel, dutyId);

    } catch (e) {
      // Hata mesajı göster
      Fluttertoast.showToast(
        msg: "Stok ekleme hatası: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  void _showConfirmFinishDialog(BuildContext context, AfterDutyListPageViewModel viewModel, String dutyId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Görevi Bitir'),
          content: Text('Görevi bitirmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: Text('Evet', style: TextStyle(color: Color(0xFF172a31))),
              onPressed: () {
                // Görevi bitirme işlemi
                viewModel.finishDuty(dutyId);
                Navigator.of(context).pop(); // Dialogu kapat
              },
            ),
          ],
        );
      },
    );
  }
}