import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/details_controller.dart';

class CustomReview extends GetView<DetailsController>{
  const CustomReview({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsController controller=Get.put(DetailsController());
    return Container(
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
    );
  }
}