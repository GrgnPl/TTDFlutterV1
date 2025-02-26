import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/home/profile/ProfilePage.dart';

import '../../../models/rest/responses/duty/Duty.dart';
import '../../../models/rest/responses/lostProperty/LostProperty.dart';
import '../../../models/rest/responses/room/GetAllRoomByBranchId.dart';
import '../../../models/rest/responses/room/Room.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../home/HomePageViewModel.dart';
import 'LostPropertyPageViewModel.dart';

class LostPropertyPage extends StatelessWidget {
  final LostPropertyPageViewModel viewModel = Get.put(LostPropertyPageViewModel());

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
          color: Colors.white, //change your color here
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ya da istediğiniz herhangi bir icon
          onPressed: () {
            TTDNavigator().pushToMain(NavigationPage()); // Geri gitme işlemi
          },
        ),

      ),
      body: FutureBuilder<List<LostProperty>>(
        future: viewModel.getAllLostProperty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              child: Text('Kayıp Eşya Talebi Yok'),
            );
          } else {
            List<LostProperty> dutyList = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Kayıp Eşya Bildirimleri",
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
                        LostProperty item = dutyList[index];
                        if (item.delivered == false) return Container(); // delivered false ise atlanır.
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Eşya Adı : ${item.propertyName}' ?? 'Bilinmeyen Eşya',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Eşya Açıklaması : ${item.description}' ?? 'Bilinmeyen Açıklama',
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(item.propertyName ?? 'Bilinmeyen Eşya',style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Açıklama: ${item.description}'),
                                          Text('Değerli mi: ${item.itemValuable == true ? "Evet" : "Hayır"}'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Kapat',style: TextStyle(color: Color(0xFF172a31))),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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
          print('Kayıp eşya bildirimi talebi');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
void _showLostPropertyDialog(BuildContext context) {
  final LostPropertyPageViewModel viewModel = Get.put(LostPropertyPageViewModel());

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
        title: Text('Kayıp Eşya Bildirimi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Eşya Adı
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Eşya Adı'),
              ),
              SizedBox(height: 10),
              // Eşya Açıklaması
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Eşya Açıklaması'),
              ),
              SizedBox(height: 10),
              // Oda seçimi
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
                      delegate: RoomSearchDelegate(viewModel.roomList.toList()),
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
              SizedBox(height: 10),
              // Eşya değerli mi? dropdown (başlangıçta null olacak)
              Obx(() {
                return DropdownButton<String>(
                  isExpanded: true,
                  value: isValuable.value.isEmpty ? null : isValuable.value,
                  hint: Text('Eşya Değerli mi?'),
                  onChanged: (newValue) {
                    isValuable.value = newValue!;
                  },
                  items: valuableOptions.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('İptal',style: TextStyle(color: Color(0xFF172a31))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Kaydet',style: TextStyle(color: Color(0xFF172a31))),
            onPressed: () {
              // Kaydetme işlemleri burada yapılacak
              var propertyName = itemNameController.text;
              var propertyDesc = descriptionController.text;
              var roomId = selectedRoom.value; // selectedRoom'un .value ile erişimine dikkat edin
              var itemVal = isValuable.value == "Evet" ? true : false; // "Evet" true, "Hayır" false olarak ayarlanıyor

              print('Değerli mi?: ${isValuable.value.isEmpty ? "Seçilmedi" : isValuable.value}');
              Navigator.of(context).pop();

              // viewModel'deki addLostProperty fonksiyonunu çağırıyoruz
              viewModel.addLostProperty(propertyName, propertyDesc, roomId, itemVal);
            },
          ),
        ],
      );
    },
  );
}

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