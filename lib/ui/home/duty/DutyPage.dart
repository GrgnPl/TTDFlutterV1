import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/navigation/TTDNavigator.dart';
import '../currentDuty/ditySituation/DutySituationPage.dart';
import 'DutyPageViewModel.dart';

class DutyPage extends StatelessWidget {
  final viewModel = Get.put(DutyPageViewModel());

  Future<void> _refreshData() async {
    try {
      await viewModel.fetchDuties();
    } catch (e) {
      print('Yenileme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          // Arama Barı
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: TextField(
              onChanged: (value) => viewModel.searchDuties(value),
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF172a31),
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: 'Görev Ara...',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
                prefixIcon: Icon(Icons.search, color: Color(0xFF172a31)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide(color: Color(0xFF172a31)),
                ),
              ),
            ),
          ),
          // Liste
          Expanded(
            child: RefreshIndicator(
              color: Color(0xFF172a31),
              onRefresh: _refreshData,
              child: Obx(() {
                if (viewModel.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF172a31)),
                    ),
                  );
                }

                if (viewModel.filteredDuties.isEmpty) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: 80.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, size: 15.w, color: Colors.blue),
                            SizedBox(height: 2.h),
                            Text(
                              'Görev bulunmamaktadır',
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
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  itemCount: viewModel.filteredDuties.length,
                  itemBuilder: (context, index) {
                    var duty = viewModel.filteredDuties[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(3.w),
                        title: Text(
                          duty.dutyTitle ?? 'Görev Adı: Bilinmiyor',
                          style: TextStyle(
                            color: Color(0xFF172a31),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Icon(Icons.description, size: 5.w, color: Colors.grey[600]),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    duty.dldDescription ?? 'Açıklama bulunmuyor',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (duty.task != null && duty.task!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 0.5.h),
                                child: Row(
                                  children: [
                                    Icon(Icons.task, size: 5.w, color: Colors.grey[600]),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Text(
                                        duty.task!.first.taskDescription ?? 'Görev detayı bulunmuyor',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF172a31),
                          size: 5.w,
                        ),
                        onTap: () => viewModel.goToDutyDetail(duty.id ?? ''),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}