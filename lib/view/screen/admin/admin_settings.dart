import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_setting_controller.dart';

class AdminSetting extends StatelessWidget {
  const AdminSetting({super.key});

  @override
  Widget build(BuildContext context) {
    AdminSettingController controller=Get.put(AdminSettingController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: const Text('LogOut',style: TextStyle(color: Colors.black,fontSize: 20),),
                trailing: IconButton(onPressed: (){
                  controller.logOut();
                }, icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.lightBlueAccent,
                ),)
              )
            ],
          ),
        ));
  }
}
