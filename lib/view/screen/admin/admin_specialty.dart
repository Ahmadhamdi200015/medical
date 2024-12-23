import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/admin/admin_specialty_controller.dart';

class AdminSpecialty extends StatelessWidget {
  const AdminSpecialty({super.key});

  @override
  Widget build(BuildContext context) {
    AdminSpecialtyController controller = Get.put(AdminSpecialtyController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Specialty'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.specialtyController,
                decoration: InputDecoration(
                    labelText: 'specialtyName',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.specialtyDescController,
                decoration: InputDecoration(
                    labelText: 'specialty Description',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
             MaterialButton(
               minWidth: MediaQuery.sizeOf(context).width/1,
              padding: const EdgeInsets.symmetric(vertical: 13),
              color: Colors.lightBlueAccent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                controller.addSpecialty(controller.specialtyController.text, controller.specialtyDescController.text);
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
