import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/doctor/doctor_screen_controller.dart';

import '../../widget/custtombottombar.dart';

class DoctorHomeScreen extends StatelessWidget{
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DoctorScreenController controller=Get.put(DoctorScreenController());
    return GetBuilder<DoctorScreenController>(builder: (controller) {
      return Scaffold(
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
                    active: controller.currentpage == 0 ? true : false,
                    iconBottom: Icons.home_outlined,
                  ),
                  CusttomBottomBar(
                    textBottom: controller.titlebottombar[1],
                    onPressed: () {
                      controller.changePage(1);
                    },
                    active: controller.currentpage == 1 ? true : false,
                    iconBottom: Icons.rate_review_outlined,
                  ),
                  CusttomBottomBar(
                    textBottom: controller.titlebottombar[2],
                    onPressed: () {
                      controller.changePage(2);
                    },
                    active: controller.currentpage == 2 ? true : false,
                    iconBottom: Icons.format_list_bulleted_outlined,
                  ),


            ],
          ),

        ),
        body: Container(child:controller.listPage.elementAt(controller.currentpage) ,),
      );
    },);
  }
}