import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_home_controller.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    AdminHomeController controller = Get.put(AdminHomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminHome'),
        centerTitle: true,
      ),
      body: GetBuilder<AdminHomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.users.isEmpty) {
            return const Center(
              child: Text('No Data'),
            );
          }
          return ListView.separated(
            itemCount: controller.users.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user['name'] ?? 'Unknown Name'), // اسم المستخدم
                subtitle: Text('Role: ${user['role']}'), // دور المستخدم
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // زر القبول
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: ()async {
                        if(controller.users[index]['role']=='doctor'){
                          controller.acceptDoctor(user['id'],user['specialtyId']);
                        }
                        controller.acceptRequest(user['id']);
                      },
                    ),
                    // زر الرفض
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        controller.rejectRequest(user['id']);
                      },
                    ),
                  ],
                ),// البريد الإلكتروني
              );
            },
          );
        },
      ),
    );
  }
}
