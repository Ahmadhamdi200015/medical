import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medicall/controller/doctor/doctor_completed_controller.dart';

import '../../../controller/doctor/doctor_home_controller.dart';
import '../../widget/handlingdataview.dart';

class CompletedPage extends StatelessWidget{
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    DoctorCompletedController controller=Get.put(DoctorCompletedController());
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: GetBuilder<DoctorCompletedController>(builder: (controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: ListView.separated(
          itemCount: controller.appointments.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 5,
          ),
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: ListTile(
                title: Text(controller.appointments[index]['patientName']),
                subtitle: Text('${controller.appointments[index]['appointmentTime']} pm - ${controller.appointments[index]['appointmentEnd']} pm'),
                trailing: MaterialButton(padding: const EdgeInsets.symmetric(vertical: 10),color: Colors.lightBlueAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),onPressed: (){},child: Text('Completed',style: TextStyle(color: Colors.white),),)
              ),
            );
          },
        ),),)
    );
  }
}