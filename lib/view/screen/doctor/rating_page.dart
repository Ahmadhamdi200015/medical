import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/doctor/doctor_rating_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class RatingPage extends StatelessWidget{
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    DoctorRatingController controller=Get.put(DoctorRatingController());
    return GetBuilder<DoctorRatingController>(builder: (controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemCount: controller.rating.length,
        separatorBuilder: (context, index) => const SizedBox(height: 2,),
        itemBuilder: (context, index) {
          return Card(
              color: Colors.white,
              child:
              ListTile(
                title: Text('${controller.rating[index]['title']}',style: const TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text('${controller.rating[index]['review']}'),leading: const Icon(Icons.person),
              )

          );
        },



      ),
    )),);
  }
}