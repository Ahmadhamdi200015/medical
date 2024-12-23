import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/signup_controller.dart';

import '../../core/function/validinput.dart';
import '../../core/shared/drop_list_down.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: GetBuilder<SignupController>(builder: (controller) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/medical.png',
                      width: 100,
                      height: 100,
                    ),
                    const Text('Hello there !',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const Text(
                      'Welcome',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const Text(
                      'SignIn to continue with your Email',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),

                    DropListDown(
                      enabled: controller.selectedValue=='doctor'?true :false,
                      title: "Choose CategoryName",
                      hint: "Enter Category Name",
                      validator: (val){
                        return validInput(val!, 1, 20, "type");
                      },
                      dropDownSelectedName: controller.catName,
                      dropDownSelectedId: controller.catId,
                      listData: controller.specialties,
                    ),
                    const Text('Role : '),
                    RadioListTile(
                      title: const Text('patient'),
                      value: 'patient',
                      groupValue: controller.selectedValue,
                      onChanged: (value) {
                        controller.changeValue(value);

                      },
                    ),
                    RadioListTile(
                      title: const Text('doctor'),
                      value: 'doctor',
                      groupValue: controller.selectedValue,
                      onChanged: (value) {
                        controller.changeValue(value);
                      },
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: MaterialButton(
                        color: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        minWidth: MediaQuery.sizeOf(context).width,
                        onPressed: () {
                          controller.signUpWithEmailPassword();
                        },
                        child: const Text(
                          'SignUp',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async{
                          controller.goToLoginPage();
                        },
                        child: const Text(
                            textAlign: TextAlign.center, 'you are a member? Login Now'),
                      ),
                    )
                  ],
                ),
              );
            },)),
      ),
    );
  }
}
