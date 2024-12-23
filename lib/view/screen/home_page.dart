import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage'), centerTitle: true,),
      body: Container()
    );
  }
}
