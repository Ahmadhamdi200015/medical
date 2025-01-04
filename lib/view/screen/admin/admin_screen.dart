import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_screen_controller.dart';

import '../../widget/custtombottombar.dart';

class AdminScreen extends StatelessWidget{
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AdminScreenController controller=Get.put(AdminScreenController());
    return GetBuilder<AdminScreenController>(builder: (controller) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            controller.goToSettingPage();
          },
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.white,
        bottomNavigationBar:BottomAppBar(
          color:Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CusttomBottomBar(
                textBottom: controller.titlebottombar[0],
                onPressed: () {
                  controller.changePage(0);
                },
                active: controller.currentPage == 0 ? true : false,
                iconBottom: Icons.home_outlined,
              ),
              CusttomBottomBar(
                textBottom: controller.titlebottombar[1],
                onPressed: () {
                  controller.changePage(1);
                },
                active: controller.currentPage == 1 ? true : false,
                iconBottom: Icons.rate_review_outlined,
              ),
              CusttomBottomBar(
                textBottom: controller.titlebottombar[2],
                onPressed: () {
                  controller.changePage(2);
                },
                active: controller.currentPage == 2 ? true : false,
                iconBottom: Icons.format_list_bulleted_outlined,
              ),
              CusttomBottomBar(
                textBottom: controller.titlebottombar[3],
                onPressed: () {
                  controller.changePage(3);
                },
                active: controller.currentPage == 3 ? true : false,
                iconBottom: Icons.analytics_outlined,
              ),

            ],
          ),

        ),
        body: Container(child:controller.listPage.elementAt(controller.currentPage) ,),
      );
    },);
  }
}