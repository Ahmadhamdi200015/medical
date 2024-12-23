import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_advice_controller.dart';

class AdminAdvice extends StatelessWidget{
  const AdminAdvice({super.key});

  @override
  Widget build(BuildContext context) {
    AdminAdviceController controller=Get.put(AdminAdviceController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Advice'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controller.adviceController,
                decoration: InputDecoration(
                    labelText: 'specialtyName',
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
                controller.addTip(controller.adviceController.text);
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