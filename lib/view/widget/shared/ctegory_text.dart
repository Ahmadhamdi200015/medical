import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/patient_controller.dart';

class CategoryText extends GetView<PatientController> {
  final String txtCategory;
  final int i;

  const CategoryText({super.key, required this.txtCategory, required this.i});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(builder: (controller)=>InkWell(
      onTap: () {
        controller.getDoctorsBySpecialty(
            controller.specialties[i]['id']);
        controller.changeChoose(i);
      },
      child: Container(
        width: 80,
        height: 20,
        alignment: Alignment.center,
        decoration: controller.selectedCat == i
            ? BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.lightBlueAccent)
            : null,
        child: Text(
          txtCategory,
          style: TextStyle(
              color:controller.selectedCat==i?Colors.white: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
