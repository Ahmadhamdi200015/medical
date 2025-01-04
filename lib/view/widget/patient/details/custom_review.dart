import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/details_controller.dart';

class CustomReview extends GetView<DetailsController> {
  const CustomReview({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsController controller = Get.put(DetailsController());
    return Scaffold(
      bottomNavigationBar: Container(child: Row(children: [
        TextFormField(),
        MaterialButton(onPressed: (){},child: Text('Enter'),)
      ],),),
    );
  }
}
