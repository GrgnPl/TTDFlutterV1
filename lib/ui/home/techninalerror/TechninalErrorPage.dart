import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ttd/models/rest/responses/techninalerror/TechninalError.dart';
import 'package:ttd/ui/home/qr/StartDutyPage.dart';import '../../../models/rest/responses/lostProperty/LostProperty.dart';


import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
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

// Önce yeni bir SearchDelegate sınıfı oluşturalım
class RoomSearchDelegate extends SearchDelegate<GetAllRoomByBranchId?> {
  final List<GetAllRoomByBranchId> rooms;

  RoomSearchDelegate(this.rooms);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? rooms
        : rooms.where((room) {
            return room.roomName?.toLowerCase().contains(query.toLowerCase()) ?? false;
          }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final room = suggestions[index];
        return ListTile(
          title: Text(room.roomName ?? 'Bilinmeyen Oda'),
          onTap: () {
            close(context, room);
          },
        );
      },
    );
  }
}

void _showLostPropertyDialog(BuildContext context) {
  final TechninalErrorPageViewModel viewModel = Get.put(TechninalErrorPageViewModel());
  final searchController = TextEditingController();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var selectedRoom = ''.obs;
  var filteredRooms = <GetAllRoomByBranchId>[].obs;

  // Odaları doldurmak için
  viewModel.getRoomsByBranchId(viewModel.branchId ?? '').then((_) {
    filteredRooms.assignAll(viewModel.roomList);
  });

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Teknik Arıza Talebi Aç',
          style: TextStyle(
            color: Color(0xFF172a31),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hata Başlığı
              TextField(
                controller: itemNameController,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF172a31),
                ),
                decoration: InputDecoration(
                  labelText: 'Hata Başlığı',
                  labelStyle: TextStyle(color: Color(0xFF172a31)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF172a31)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Hata Açıklaması
              Container(
                height: 150,
                child: TextField(
                  controller: descriptionController,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF172a31),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Hata Açıklaması',
                    labelStyle: TextStyle(color: Color(0xFF172a31)),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF172a31)),
                    ),
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
              SizedBox(height: 16),
              
              // Dropdown ve Arama
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () async {
                    final selectedResult = await showSearch(
                      context: context,
                      delegate: RoomSearchDelegate(viewModel.roomList),
                    );
                    if (selectedResult != null) {
                      selectedRoom.value = selectedResult.id ?? '';
                    }
                  },
                  child: Obx(() {
                    final selected = viewModel.roomList.firstWhereOrNull(
                      (room) => room.id == selectedRoom.value
                    );
                    
                    return Container(
                      height: 48,
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFF172a31)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selected?.roomName ?? 'Bulunduğu Oda',
                              style: TextStyle(
                                color: selected == null ? Colors.grey[600] : Color(0xFF172a31),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Color(0xFF172a31)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('İptal', style: TextStyle(color: Color(0xFF172a31))),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF172a31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Kaydet', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (itemNameController.text.isEmpty || 
                  descriptionController.text.isEmpty || 
                  selectedRoom.value.isEmpty) {
                Get.snackbar(
                  'Hata',
                  'Lütfen tüm alanları doldurunuz',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              Navigator.of(context).pop();
              viewModel.addTechnicalError(
                itemNameController.text,
                descriptionController.text,
                selectedRoom.value
              );
            },
          ),
        ],
      );
    },
  );
}