import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/login_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
        appBar: AppBar(),
        body: GetBuilder<LoginController>(
          builder: (controller) {
            return HandlingDataView(statusRequest: controller.statusRequest, widget: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                  child: SizedBox(
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
                            controller: controller.emailLoginController,
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
                            obscureText: true,
                            controller: controller.passwordLoginController,
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
                          child: MaterialButton(
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            minWidth: MediaQuery.sizeOf(context).width,
                            onPressed: () {
                              controller.signInWithEmailPassword();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              controller.goToSignUpPage();
                            },
                            child: const Text(
                                textAlign: TextAlign.center,
                                'not a member? Sign Up Now'),
                          ),
                        )
                      ],
                    ),
                  )),
            ));
          },
        ));
  }
}
