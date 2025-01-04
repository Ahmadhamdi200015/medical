import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/shared/otp_page_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    OtpPageController controller = Get.put(OtpPageController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify User'),
          centerTitle: true,
        ),
        body: GetBuilder<OtpPageController>(
          builder: (controller) => HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Enter Your VerifyCode',style: TextStyle(color: Colors.black,fontSize: 22),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: controller.otpText,
                    decoration: InputDecoration(
                      labelText: 'OtpCode',
                        filled: true,
                        hintText: 'xxxxx',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(height: 20,),
                  MaterialButton(
                    minWidth: MediaQuery.sizeOf(context).width/1,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: ()async {
                    await  controller.confirmUser();
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
