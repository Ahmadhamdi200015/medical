import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_details_controller.dart';

class AdminDetails extends StatelessWidget {
  const AdminDetails({super.key});

  @override
  Widget build(BuildContext context) {
    AdminDetailsController controller = Get.put(AdminDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: controller.fileName!.isNotEmpty
          ? Center(
              child: Image.file(
                  width: MediaQuery.sizeOf(context).width / 2,
                  height: MediaQuery.sizeOf(context).height / 2,
                  File(controller.fileName!)),
            )
          : const Center(
              child: Text('NoImageFound'),
            ),
    );
  }
}
