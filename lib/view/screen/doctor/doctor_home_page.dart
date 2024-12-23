import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/doctor/doctor_home_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DoctorHomeController controller = Get.put(DoctorHomeController());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: GetBuilder<DoctorHomeController>(builder: (controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: ListView.separated(
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
              trailing:Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر القبول
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      controller.approveAppointment(controller.appointments[index]['appointmentId']);
                    },
                  ),
                  // زر الرفض
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      controller.rejectAppointment(controller.appointments[index]['appointmentId']);
                    },
                  ),
                ],
              ) ,
            ),
          );
        },
      ),),)
    );
  }
}
