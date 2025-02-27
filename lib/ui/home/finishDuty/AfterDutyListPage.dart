import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/ui/home/finishDuty/AfterDutyListPageViewModel.dart';
import 'package:ttd/ui/home/finishDuty/FinishTakePhotoPageViewModel.dart';
import 'package:ttd/utils/navigation/TTDNavigator.dart';

class AfterDutyListPage extends StatelessWidget {
  final String dutyId;
  final finishTakePhotoPageViewModel = Get.put(FinishTakePhotoPageViewModel());

  AfterDutyListPage({required this.dutyId});

  @override
  Widget build(BuildContext context) {
    print("gelen dutyID iş bitiriş $dutyId");
    final viewModel = Get.put(AfterDutyListPageViewModel());
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Color(0xFF172a31),
        centerTitle: true,
        title: Image.asset(
          'assets/1.png',
          width: 25.w,
          height: 12.h,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 7.w),
          onPressed: () => TTDNavigator().pop(),
        ),
      ),
      body: FutureBuilder<void>(
        future: finishTakePhotoPageViewModel.getDutyByDutyId(dutyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 15.w, color: Colors.red),
                  SizedBox(height: 2.h),
                  Text(
                    'Hata oluştu: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (dutyId == null || dutyId.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 15.w, color: Colors.orange),
                  SizedBox(height: 2.h),
                  Text(
                    'Görev bulunamadı.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          } else {
            var activeTasks =finishTakePhotoPageViewModel.dutyList.where((task) => task.status == true).toList();

            if (activeTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 15.w, color: Colors.blue),
                    SizedBox(height: 2.h),
                    Text(
                      'Bu Odaya Atanmış Görev Yoktur',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            var gorevAdi = finishTakePhotoPageViewModel.dutyList.first.dutyTitle;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$gorevAdi",
                    style: TextStyle(
                      color: Color(0xFF172a31),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: finishTakePhotoPageViewModel.dutyList.first.task?.length ?? 0,
                      itemBuilder: (context, index) {
                        var task = finishTakePhotoPageViewModel.dutyList.first.task![index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(3.w),
                            leading: Icon(
                              Icons.check_circle,
                              color: Color(0xFF2D75FD),
                              size: 8.w,
                            ),
                            title: Text(
                              task.taskName?? 'Başlık Yok',
                              style: TextStyle(
                                color: Color(0xFF172a31),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                task.taskDescription ?? 'Açıklama yok',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: SizedBox(
                      width: 90.w,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Giden duty ID ${dutyId}");

                          _showFinishTaskDialog(context, viewModel, dutyId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF172a31),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Görevi Bitir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          title: Text(
            'Oda Envanterleri',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              color: Color(0xFF172a31),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...viewModel.materials.map((material) {
                  int index = viewModel.materials.indexOf(material);
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            material.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _buildCounterButton(
                              Icons.remove,
                              Colors.red,
                              () {
                                int currentValue = int.parse(quantityControllers[index].text);
                                if (currentValue > 0) {
                                  currentValue--;
                                  quantityControllers[index].text = currentValue.toString();
                                }
                              },
                            ),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width: 10.w,
                              child: TextField(
                                controller: quantityControllers[index],
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            _buildCounterButton(
                              Icons.add,
                              Colors.green,
                              () {
                                int currentValue = int.parse(quantityControllers[index].text);
                                currentValue++;
                                quantityControllers[index].text = currentValue.toString();
                              },
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
          actions: [
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(
                  color: Color(0xFF172a31),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF172a31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              child: Text(
                'Envanter Kaydet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () => _handleStockAndFinishDuty(context, viewModel, dutyId, quantityControllers),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCounterButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 8.w,
      height: 8.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: color,
          shape: CircleBorder(),
        ),
        child: Icon(icon, color: Colors.white, size: 5.w),
      ),
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