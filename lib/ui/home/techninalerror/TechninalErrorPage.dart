import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechninalError.dart';
import 'package:ttd/ui/home/qr/StartDutyPage.dart';import '../../../models/rest/responses/lostProperty/LostProperty.dart';


import '../../../utils/navigation/TTDNavigator.dart';
import '../NavigationPage.dart';
import 'TechninalErrorPageViewModel.dart';


class TechninalErrorPage extends StatelessWidget {
  final TechninalErrorPageViewModel viewModel = Get.put(TechninalErrorPageViewModel());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.fetchEmployeeInfoAndRooms();
      viewModel.getTechnicalErrorByDeparmentId();
    });
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
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            TTDNavigator().pushToMain(NavigationPage());
          },
        ),

      ),
      body: FutureBuilder<List<TechninalError>>(
        future: viewModel.getTechnicalErrorByDeparmentId(),
        builder: (context, snapshot) {
          if (viewModel.technicalDutyLoading.value) {
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Teknik Arıza Talebi Yok'),
            );
          } else {
            List<TechninalError> dutyList = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Teknik Hata Bildirimleri",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dutyList.length,
                      itemBuilder: (context, index) {
                        TechninalError item = dutyList[index];
                        String? technicalDutyId = item.id;
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Teknik Hata Adı : ${item.errorTitle}' ?? 'Bilinmeyen Hata',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Teknik Hata Açıklaması : ${item.errorDescription}' ?? 'Bilinmeyen Açıklama',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      "Teknik Görevi Bitirme Talebi",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Teknik Görevi Bitirmek İstiyor Musunuz?",style: TextStyle(
                                          fontSize: 16
                                        ),)
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "İptal",
                                          style: TextStyle(color: Color(0xFF172a31)),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          viewModel.finishTechnicalDuty(technicalDutyId!);
                                        },
                                        child: Text(
                                          "Teknik Görevi Bitir",
                                          style: TextStyle(color: Color(0xFF172a31)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );

                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLostPropertyDialog(context);
          print('Teknik Arıza Talebi');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
void _showLostPropertyDialog(BuildContext context) {
  final TechninalErrorPageViewModel viewModel = Get.put(TechninalErrorPageViewModel());

  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var selectedRoom = ''.obs; // Seçilen oda için reaktif bir değişken
  var isValuable = ''.obs; // Değerli mi seçeneğini reaktif hale getiriyoruz

  // Dropdown menü verileri için
  List<String> valuableOptions = ['Evet', 'Hayır'];

  // Odaları doldurmak için
  viewModel.getRoomsByBranchId(viewModel.branchId ?? ''); // branchId getter'ı kullanılıyor

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Teknik Arıza Talebi Aç'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hata Başlığı
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Hata Başlığı'),
              ),
              SizedBox(height: 10),
              // Hata Açıklaması (Büyütülmüş alan)
              SizedBox(
                height: 150,  // Görünümü büyütmek için yüksekliği ayarlıyoruz
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Hata Açıklaması'),
                  maxLines: null, // Satır sayısını serbest bırakıyoruz
                  expands: true,  // Alanın tüm yüksekliği kullanmasını sağlıyor
                ),
              ),
              SizedBox(height: 10),
              // Oda seçimi
              Obx(() {
                if (viewModel.roomList.isEmpty) {
                  return Text('Oda bulunamadı'); // Eğer odalar yoksa mesaj göster
                } else {
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: selectedRoom.value.isEmpty ? null : selectedRoom.value,
                    hint: Text('Bulunduğu Oda'),
                    onChanged: (newValue) {
                      selectedRoom.value = newValue ?? ''; // Seçilen oda değerini güncelle
                    },
                    items: viewModel.roomList.map((room) {
                      return DropdownMenuItem<String>(
                        value: room.id,
                        child: Text(room.roomName ?? 'Bilinmeyen Oda'),
                      );
                    }).toList(),
                  );
                }
              }),
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
            child: Text('Kaydet', style: TextStyle(color: Color(0xFF172a31))),
            onPressed: () {
              var propertyName = itemNameController.text;
              var propertyDesc = descriptionController.text;
              var roomId = selectedRoom.value;

              Navigator.of(context).pop();

              viewModel.addTechnicalError(propertyName, propertyDesc, roomId);
            },
          ),
        ],
      );
    },
  );
}