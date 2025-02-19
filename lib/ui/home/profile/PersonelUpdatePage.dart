
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'PersonelUpdatePageViewModel.dart';
import 'ProfilePageViewModel.dart';

class PersonelUpdatePage extends StatelessWidget {
  final PersonelUpdatePageViewModel _personelUpdatePageViewModel = Get.put(PersonelUpdatePageViewModel());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  String? dateOfStart;
  String? employeeId;
  String? departmentId;
  String? branchId;
  late bool status;

  @override
  Widget build(BuildContext context) {
    final ProfilPageViewModel profileViewModel = Get.find<ProfilPageViewModel>();

    final employeeInfo = profileViewModel.employeeInfo;

    if (employeeInfo != null) {
      emailController.text = employeeInfo.email ?? '';
      firstNameController.text = employeeInfo.firstName ?? '';
      lastNameController.text = employeeInfo.lastName ?? '';
      ageController.text = employeeInfo.age.toString() ?? '';
      phoneNumberController.text = employeeInfo.phoneNumber ?? '';
      titleController.text = employeeInfo.title ?? '';
      dateOfStart = employeeInfo.dateOfStart;
      employeeId = employeeInfo.id;
      departmentId = employeeInfo.departmentId;
      branchId = employeeInfo.branchId;
      status = employeeInfo.status!;
    }

    return Scaffold(
      backgroundColor: Color(0xFF172A31),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/1.png',
              width: 200,
              height: 200,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildTextField('Email Adresi', emailController, 'örnek@gmail.com'),
                            _buildTextField('İsim', firstNameController, 'İsminizi Giriniz'),
                            _buildTextField('Soyisim', lastNameController, 'Soyisminizi Giriniz'),
                            _buildTextField('Yaş', ageController, 'Yaşınızı Giriniz', keyboardType: TextInputType.number),
                            _buildTextField('Telefon Numarası', phoneNumberController, 'Telefon Numaranızı Giriniz', keyboardType: TextInputType.phone),
                            _buildTextField('Görev', titleController, 'Görev Unvanınızı Giriniz'),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _onUpdatePressed(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2D76FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    'Güncelle',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF5F5F61).withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF8F8F8),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _onUpdatePressed(BuildContext context) {
    if (emailController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        ageController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        titleController.text.isEmpty ||
        dateOfStart == null ||
        employeeId == null ||
        departmentId == null ||
        branchId == null) {
      Fluttertoast.showToast(msg: "Lütfen tüm alanları doldurun");
      return;
    }

    _personelUpdatePageViewModel.updateEmployee(
      employeeId!,
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      departmentId!,
      ageController.text,
      phoneNumberController.text,
      dateOfStart!,
      titleController.text,
      status,
      branchId,
    );

    Fluttertoast.showToast(msg: "Güncelleme başarılı");
  }
}