import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/patient_controller.dart';
import 'package:medicall/core/extension/space_exe.dart';

class CustomDrawerPatient extends StatelessWidget{
  const CustomDrawerPatient({super.key});

  @override
  Widget build(BuildContext context) {
    PatientController controller=Get.put(PatientController());
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: 300,
        height: double.infinity,
        decoration: BoxDecoration(color: colorScheme.background),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            40.h,
            20.h,
            GestureDetector(
              onTap: () {
                controller.goToMessagePage();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: colorScheme.inversePrimary,
                  ),
                  10.w,
                  Text(
                    "Messages",
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.logOut();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: colorScheme.inversePrimary,
                  ),
                  10.w,
                  Text(
                    "LogOut",
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}